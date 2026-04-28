# I use a mac M-series chip

These things live in root `~/` :

```
.skhdrc
.yabairc
.config
```

The `editor-config/User` directory just holds my vscode/cursor User `keybindings.json` and User `settings.json` files.

I use:
* [yabai](https://github.com/koekeishiya/yabai/wiki) tiling window manager
  + I use [skhd](https://github.com/koekeishiya/skhd) to define my yabai shortcuts
  + I use [jq](https://formulae.brew.sh/formula/jq) for the crazier shortcuts
  + I have [disabled SIP](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
  + I have configured scripting addition
* [the neovim vscode extension](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
* [the which key vscode extension](https://marketplace.visualstudio.com/items?itemName=VSpaceCode.whichkey)
* [tmux](https://github.com/tmux/tmux/wiki)

Note: I have also included an [aerospace](https://nikitabobko.github.io/AeroSpace/guide) config, but I do not use aerospace. This config is literally just my yabai+skhd config translated to aerospace. I do not use aerospace because it does not support stay-on-top windows. When they build support for that, I might switch over.

It's also important to note:
* my globe key is rebound to command
* my command key is rebound to ctrl
* my ctrl key is rebound to globe
* my option key is still option

Known bugs:
* none :)

## to use these configs
generally copy paste
for `mac_shortcuts`, and `arc_shortcuts`, refer to `instructions.md`.

## keeping this repo up to date
run `update_dotfiles.sh`. i recommed adding the `update-dotfiles` alias in `.zshrc` to make it easy.
