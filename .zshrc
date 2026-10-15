# generic
alias dotfiles='code ~/Desktop/dotfiles'
alias yabai-config='code ~/.yabairc'
alias skhd-config='code ~/.skhdrc'

alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lal='ls -al --color=auto'

alias gf='git fetch'
alias gb='git branch'
alias gs='git status'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit'
alias gpull='git pull'
alias gpullr='git pull --rebase'
alias gpush='git push'
alias gpushu='git push -u origin HEAD'
alias gpushf='git push --force-with-lease'
alias gl='git log --oneline'
alias gsub='echo "git submodule update --init --recursive" \
            && git submodule update --init --recursive \
            && echo "git submodule foreach --recursive git lfs pull" \
            && git submodule foreach --recursive git lfs pull'

alias update-dotfiles='~/Desktop/dotfiles/update_dotfiles.sh'
alias rebalance='cur=$(yabai -m query --spaces --space | jq ".index"); for sid in $(yabai -m query --spaces | jq ".[].index"); do yabai -m space --focus $sid; yabai -m space --balance; done; yabai -m space --focus $cur'

alias agent='agent --mode=ask'

alias bell='printf "\a"'

parse_git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}
setopt PROMPT_SUBST
PROMPT='┌%F{117}%d%f${_git_seg}'$'\n''└%% '

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

# git add and commit 
function gitall() {
    git add .
    if [ "$1" != "" ]
    then
        git commit -m "$1"
    else
        git commit -m update # default commit message is `update`
    fi # closing statement of if-else block
}

# device list CLI reads and writes ~/.devicelist.json
dl() {
  local f=~/.devicelist.json d k t
  [ -f "$f" ] || echo '{}' > "$f"
  if [ $# -eq 0 ]; then
    jq -r 'to_entries[] | .key as $d | .value | to_entries[]
           | "\($d).\(.key) = \(.value)"' "$f"
    return
  fi
  d=${1%%.*}; k=${1#*.}; [ "$k" = "$1" ] && k=""
  if [ -n "$2" ]; then
    [ -z "$k" ] && { echo "dl: need device.field to write" >&2; return 2; }
    t=$(mktemp)
    jq --arg d "$d" --arg k "$k" --arg v "$2" '.[$d][$k] = $v' "$f" > "$t" && mv "$t" "$f"
  elif [ -n "$k" ]; then
    jq -er --arg d "$d" --arg k "$k" '.[$d][$k] // empty' "$f" \
      || { echo "dl: no '$1'" >&2; return 1; }
  else
    jq -er --arg d "$d" '.[$d] // empty' "$f" \
      || { echo "dl: no device '$d'" >&2; return 1; }
  fi
}

# usage: gx <filepath>  -- locally ignore a file (nothing committed)
#   tracked file:   git update-index --skip-worktree (undo: --no-skip-worktree)
#   untracked file: append to .git/info/exclude
gx() {
  if [[ -z "$1" ]]; then
    echo "usage: gx <filepath>" >&2
    return 1
  fi
  if git ls-files --error-unmatch -- "$1" >/dev/null 2>&1; then
    git update-index --skip-worktree -- "$1" && echo "gx: skip-worktree $1"
  else
    local exclude rel
    exclude=$(git rev-parse --git-path info/exclude) || return 1
    rel="$(git rev-parse --show-prefix)$1"
    echo "$rel" >> "$exclude" && echo "gx: excluded $rel"
  fi
}
