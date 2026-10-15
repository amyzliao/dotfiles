# tmux + VS Code

One tmux session per VS Code window (`<folder>-<hash>`), plus a `-claude` session for Claude.

- `bin/vsc-tmux [role]`: attach to or create the session for `$PWD`. It's the default VS Code terminal profile (`args: ["main"]`).
- `vscode-ext/`: VS Code extension. Install with `./vscode-ext/install.sh`.
  - **Tmux: Open Claude Terminal** (palette): opens or focuses the `-claude` session in an editor tab. After reopening a window, run it again.
  - `ctrl+h`/`ctrl+l`: move between tmux panes, then to the next VS Code area at the edge.
- `setup-remote.sh <ssh-host>`: install all of this on a sandbox.

VS Code keys (in `keybindings.json`): `cmd+t` new window · `ctrl+p`/`ctrl+n` next/prev window · `ctrl+\` split · `cmd+w` close pane · `shift+enter` newline for Claude.
