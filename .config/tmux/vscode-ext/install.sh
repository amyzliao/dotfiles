#!/bin/sh
# Package this extension and install it into VS Code. Re-run after editing, then reload the window.
set -e
cd "$(dirname "$0")"
out="$(mktemp -d)/vsc-tmux.vsix"
npx --yes @vscode/vsce@3 package --allow-missing-repository --skip-license -o "$out"
code --install-extension "$out" --force
