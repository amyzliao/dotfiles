# I use a mac M2 chip

These things live in root `~/` :

```
.skhdrc
.yabairc
.config
```

The `vscode-config/User` directory just holds my vscode User `keybindings.json` and User `settings.json` files.

I use:
* [yabai](https://github.com/koekeishiya/yabai/wiki) tiling window manager
  + I use [skhd](https://github.com/koekeishiya/skhd) to define my yabai shortcuts
  + I use [jq](https://formulae.brew.sh/formula/jq) for the crazier shortcuts
  + I have [disabled SIP](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
  + I have configured scripting addition
* [the neovim vscode extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
* [the which key vscode extension](https://marketplace.visualstudio.com/items?itemName=VSpaceCode.whichkey)
* [tmux](https://github.com/tmux/tmux/wiki)

It's also important to note:
* my globe key is rebound to command
* my command key is rebound to ctrl
* my ctrl key is rebound to globe
* my option key is still option

Bugs:
* none :)

## keeping this repo up to date

as defined in `~/.zprofile` :

```
# copy all config files to github dotfiles repo
function cpcfgs() {
    GIT_REPO="/Users/azl/Desktop/Projects-working/Coding-working/dotfiles"

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

```

to update configs, run 

```
cpcfgs
```
