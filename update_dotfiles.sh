#!/bin/bash
# Copy all config files to this dotfiles repo.
GIT_REPO="$(cd "$(dirname "$0")" && pwd)"
YABAI="$HOME/.yabairc"
SKHD="$HOME/.skhdrc"
NVIM="$HOME/.config/nvim"
TMUX="$HOME/.config/tmux"
ZSHRC="$HOME/.zshrc"
ZPROFILE="$HOME/.zprofile"

CURSOR_DIR="$HOME/Library/Application Support/Cursor/User"
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$CURSOR_DIR" ]; then
  EDITOR_DIR="$CURSOR_DIR"
elif [ -d "$VSCODE_DIR" ]; then
  EDITOR_DIR="$VSCODE_DIR"
else
  echo "Warning: Neither Cursor nor VS Code config directory found"
  EDITOR_DIR=""
fi
EDITOR_SETTINGS="$EDITOR_DIR/settings.json"
EDITOR_KEYBINDINGS="$EDITOR_DIR/keybindings.json"

cd "$GIT_REPO"
cp -f "$YABAI" .yabairc
cp -f "$SKHD" .skhdrc
cp -f "$ZSHRC" .zshrc
cp -f "$ZPROFILE" .zprofile
rm -rf .config
mkdir -p .config/nvim .config/tmux
cp -rf "$NVIM"/ .config/nvim/
cp -rf "$TMUX"/ .config/tmux/
if [ -n "$EDITOR_DIR" ]; then
  cp -f "$EDITOR_SETTINGS" editor-config/User/settings.json
  cp -f "$EDITOR_KEYBINDINGS" editor-config/User/keybindings.json
fi