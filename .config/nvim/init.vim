set clipboard+=unnamedplus

" Map <Tab> to indent lines in normal and visual mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

if exists('g:vscode')
    " VSCode extension
    source /Users/azl/.config/nvim/vscode/settings.vim
else
    " ordinary Neovim
endif

