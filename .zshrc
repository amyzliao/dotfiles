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