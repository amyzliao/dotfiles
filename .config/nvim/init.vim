set clipboard+=unnamedplus

set ignorecase
set smartcase

" Map <Tab> to indent lines in normal and visual mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

if exists('g:vscode')
    " VSCode extension
    source <sfile>:h/vscode/settings.vim
else
    " ordinary Neovim
endif

echo "nvim loaded"