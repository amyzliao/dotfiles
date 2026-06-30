# generic
alias dotfiles='code ~/Desktop/dotfiles'
alias yabai-config='code ~/.yabairc'
alias skhd-config='code ~/.skhdrc'

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lal='ls -al --color=auto'

alias gsub='echo "git submodule update --init --recursive" \
            && git submodule update --init --recursive \
            && echo "git submodule foreach --recursive git lfs pull" \
            && git submodule foreach --recursive git lfs pull'
alias gpush='git push -u origin HEAD'

alias update-dotfiles='~/Desktop/dotfiles/update_dotfiles.sh'

alias agent='agent --mode=ask'
export CURSOR_CLI_BLOCK_CURSOR_AGENT=true
export CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1

parse_git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}
setopt PROMPT_SUBST
export PROMPT='┌%F{117}%d%f${_git_seg}'$'\n''└%% '

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

# ring the bell when a command takes >30s
preexec() { CMD_START=$SECONDS }
precmd()  {
  local rc=$?
  local b=$(parse_git_branch)
  if [[ -n $b ]]; then
    _git_seg=" %F{#5c6370}on %F{218}${b}%f"
  else
    _git_seg=""
  fi
  if [[ -n $CMD_START ]] && (( SECONDS - CMD_START > 30 )); then
    printf '\a'
    print -P "%F{yellow}done in $((SECONDS - CMD_START))s (rc=$rc)%f"
  fi
  unset CMD_START
}
