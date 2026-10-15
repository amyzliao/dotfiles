#!/bin/sh
# Install this tmux + VS Code setup on a remote host (e.g. a sandbox). Re-run to update.
# usage: ./setup-remote.sh <ssh-host>
set -e
host="$1"
[ -n "$host" ] || { echo "usage: $0 <ssh-host>"; exit 1; }
here="$(cd "$(dirname "$0")" && pwd)"

echo "== copying ~/.config/tmux to $host"
rsync -a --exclude .DS_Store "$here/" "$host:.config/tmux/"

echo "== packaging VS Code extension"
vsix="$(mktemp -d)/vsc-tmux.vsix"
(cd "$here/vscode-ext" && npx --yes @vscode/vsce@3 package --allow-missing-repository --skip-license -o "$vsix" >/dev/null)
scp -q "$vsix" "$host:/tmp/vsc-tmux.vsix"

echo "== installing on $host"
ssh "$host" sh -s <<'EOF'
set -e
mkdir -p ~/.local/bin
ln -sfn ~/.config/tmux/bin/vsc-tmux ~/.local/bin/vsc-tmux
# all VS Code server versions share ~/.vscode-server/extensions, so any code-server binary will do
server="$(ls -t ~/.vscode-server/cli/servers/*/server/bin/code-server 2>/dev/null | head -1)"
if [ -n "$server" ]; then
    "$server" --install-extension /tmp/vsc-tmux.vsix --force
else
    echo "no VS Code server found; open a remote window once, then re-run" >&2
fi
rm -f /tmp/vsc-tmux.vsix
tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true   # reload if a server is running
EOF
echo "== done. Reload any open VS Code windows for $host."
