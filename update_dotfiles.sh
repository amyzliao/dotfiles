#!/bin/bash
# Copy all config files to this dotfiles repo.
GIT_REPO="$(cd "$(dirname "$0")" && pwd)"
YABAI="$HOME/.yabairc"
SKHD="$HOME/.skhdrc"
NVIM="$HOME/.config/nvim"
TMUX="$HOME/.config/tmux"
ZSHRC="$HOME/.zshrc"
ZPROFILE="$HOME/.zprofile"
AEROSPACE="$HOME/.aerospace.toml"

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
EDITOR_SETTINGS="$VSCODE_DIR/settings.json"
EDITOR_KEYBINDINGS="$VSCODE_DIR/keybindings.json"
CLAUDE_DIR="$HOME/.claude"

cd "$GIT_REPO"
cp -f "$YABAI" .yabairc
cp -f "$SKHD" .skhdrc
cp -f "$ZSHRC" .zshrc
cp -f "$ZPROFILE" .zprofile
cp -f "$AEROSPACE" .aerospace.toml
rm -rf .config
mkdir -p .config/nvim .config/tmux
cp -rf "$NVIM"/ .config/nvim/
cp -rf "$TMUX"/ .config/tmux/
if [ -d "$VSCODE_DIR" ]; then
  cp -f "$EDITOR_SETTINGS" editor-config/User/settings.json
  cp -f "$EDITOR_KEYBINDINGS" editor-config/User/keybindings.json
else
  echo "Warning: VS Code config directory not found"
fi

# claude code
if [ -d "$CLAUDE_DIR" ]; then
  mkdir -p claude-config
  cp -f "$CLAUDE_DIR/CLAUDE.md" claude-config/CLAUDE.md
  cp -f "$CLAUDE_DIR/settings.json" claude-config/settings.json
else
  echo "Warning: Claude Code config directory not found"
fi

# mac shortcuts
mkdir -p mac_shortcuts
defaults export com.apple.symbolichotkeys "$GIT_REPO/mac_shortcuts/symbolichotkeys.plist"
plutil -convert xml1 "$GIT_REPO/mac_shortcuts/symbolichotkeys.plist"
MAC_VERSION="$(sw_vers -productVersion)"
sed -i '' "s/^MAC_VERSION: .*/MAC_VERSION: $MAC_VERSION/" "$GIT_REPO/mac_shortcuts/instructions.md"

# arc shortcuts
ARC_KEYBINDINGS="$HOME/Library/Application Support/Arc/StorableKeyBindings.json"
if [ -f "$ARC_KEYBINDINGS" ]; then
  mkdir -p arc_shortcuts
  cp -f "$ARC_KEYBINDINGS" "$GIT_REPO/arc_shortcuts/StorableKeyBindings.json"
fi
