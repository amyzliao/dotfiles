set clipboard+=unnamedplus

if exists('g:vscode')
    " VSCode extension
    source /Users/azl/.config/nvim/vscode/settings.vim
else
    " ordinary Neovim
endif