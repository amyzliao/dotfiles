# generic
alias dotfiles='code ~/Desktop/dotfiles'
alias yabai-config='code ~/.yabairc'
alias skhd-config='code ~/.skhdrc'

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lal='ls -al --color=auto'

alias gsub='git submodule update --init --recursive && git submodule foreach --recursive git lfs pull'

alias update-dotfiles='~/Desktop/dotfiles/update_dotfiles.sh'

alias agent='agent --mode=ask'
export CURSOR_CLI_BLOCK_CURSOR_AGENT=true

parse_git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}
setopt PROMPT_SUBST
export PROMPT='┌%F{114}%n %F{117}%d %F{218}$(parse_git_branch)%f'$'\n''└%% '

## enable vi mode in line editor
bindkey -v
### backspace works as normal
bindkey -M viins '^?' backward-delete-char
### Reduce mode switching delay (default is 0.4s)
export KEYTIMEOUT=1
### Re-enable ctrl-r for reverse history search (vi mode disables it)
bindkey -M viins '^R' history-incremental-search-backward
### Show cursor shape based on mode (block for normal, beam for insert)
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[2 q'  # block cursor
  else
    echo -ne '\e[6 q'  # beam cursor
  fi
}
zle -N zle-keymap-select
### Start with beam cursor
function zle-line-init { echo -ne '\e[6 q' }
zle -N zle-line-init
### vi yank copies to clipboard
function vi-yank-pbcopy {
  zle vi-yank
  echo -n "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-pbcopy
bindkey -M vicmd 'y' vi-yank-pbcopy
