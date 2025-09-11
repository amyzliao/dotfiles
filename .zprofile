alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# git add . && git commit -m "message"
function gitall() {
    git add .
    if [ "$1" != "" ]
    then
        git commit -m "$1"
    else
        git commit -m update # default commit message is `update`
    fi # closing statement of if-else block
}

# copy all config files to github dotfiles repo
# note: .zprofile copied manually
function cpcfgs() {
    GIT_REPO="<path to this repo>"

    YABAI=~/.yabairc
    SKHD=~/.skhdrc
    NVIM=~/.config/nvim
    TMUX=~/.config/tmux
    VSC_SETTINGS=~/Library/Application\ Support/Code/User/settings.json
    VSC_KEYBINDINGS=~/Library/Application\ Support/Code/User/keybindings.json

    cd $GIT_REPO
    cp -f "$YABAI" .yabairc
    cp -f "$SKHD" .skhdrc
    rm -rf .config
    cp -rf "$CONFIG" .config
    cp -f "$VSC_SETTINGS" vscode-config/User/settings.json
    cp -f "$VSC_KEYBINDINGS" vscode-config/User/keybindings.json 
}
