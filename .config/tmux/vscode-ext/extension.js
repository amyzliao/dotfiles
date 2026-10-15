const vscode = require('vscode');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { execFile } = require('child_process');

const VSC_TMUX = path.join(os.homedir(), '.local/bin/vsc-tmux');
const CLAUDE_TERMINAL = 'claude';
// the extension host may not have homebrew on PATH
const TMUX = ['/opt/homebrew/bin/tmux', '/usr/local/bin/tmux', '/usr/bin/tmux'].find((p) => fs.existsSync(p)) || 'tmux';

const log = vscode.window.createOutputChannel('vsc-tmux');

// Run tmux; resolves to stdout, or undefined on error.
function tmux(...args) {
  return new Promise((resolve) => {
    execFile(TMUX, args, (err, stdout) => resolve(err ? undefined : stdout.trim()));
  });
}

// Attached tmux clients as Map<pid, {pane, atLeft, atRight}>, where pane is the client's current pane.
// Each tmux-backed VS Code terminal's process *is* a tmux client.
// (Don't use `display -c <tty>` instead: run from outside tmux, its formats resolve against some other pane.)
async function tmuxClients() {
  const format = '#{client_pid} #{pane_id} #{||:#{pane_at_left},#{window_zoomed_flag}} #{||:#{pane_at_right},#{window_zoomed_flag}}';
  const out = (await tmux('list-clients', '-F', format)) || '';
  return new Map(out.split('\n').filter(Boolean).map((line) => {
    const [pid, pane, atLeft, atRight] = line.split(' ');
    return [Number(pid), { pane, atLeft: atLeft === '1', atRight: atRight === '1' }];
  }));
}

// A dead terminal's processId may never resolve, so give up after a moment.
function pidOf(terminal) {
  return Promise.race([terminal.processId, new Promise((r) => setTimeout(() => r(undefined), 500))]);
}

// Open the claude tmux session in an editor-area terminal, or focus it if one is already open.
// VS Code sometimes keeps dead terminals in window.terminals (e.g. after "Kill All Terminals" or closing
// an editor group), so tmux decides which "claude" terminals are real.
async function openClaude() {
  const clients = await tmuxClients();
  for (const t of vscode.window.terminals.filter((t) => t.name === CLAUDE_TERMINAL)) {
    const pid = await pidOf(t);
    if (clients.has(pid)) {
      t.show();
      return;
    }
    log.appendLine(`disposing stale claude terminal (pid ${pid})`);
    t.dispose();
  }
  vscode.window.createTerminal({
    name: CLAUDE_TERMINAL,
    shellPath: VSC_TMUX,
    shellArgs: ['claude'],
    cwd: vscode.workspace.workspaceFolders?.[0]?.uri.fsPath,
    iconPath: new vscode.ThemeIcon('sparkle'),
    location: vscode.TerminalLocation.Editor,
    // Don't let VS Code restore this terminal: on remote windows its revive falls back to the default
    // profile, bringing the tab back attached to the main session. Re-run this command instead.
    isTransient: true,
  }).show();
}

const NAV = {
  left: { flag: '-L', atEdge: (c) => c.atLeft, vscode: 'workbench.action.navigateLeft' },
  right: { flag: '-R', atEdge: (c) => c.atRight, vscode: 'workbench.action.navigateRight' },
};

// Move to the tmux pane in `direction`; if already at that edge (or not in tmux), move between VS Code areas.
// A zoomed pane counts as being at every edge.
async function navigate({ direction }) {
  const nav = NAV[direction];
  const terminal = vscode.window.activeTerminal;
  const client = terminal && (await tmuxClients()).get(await pidOf(terminal));
  if (client && !nav.atEdge(client)) {
    await tmux('select-pane', '-t', client.pane, nav.flag);
    return;
  }
  await vscode.commands.executeCommand(nav.vscode);
}

function activate(context) {
  context.subscriptions.push(vscode.commands.registerCommand('vscTmux.openClaude', openClaude));
  context.subscriptions.push(vscode.commands.registerCommand('vscTmux.navigate', navigate));
}

module.exports = { activate };
