#!/usr/bin/bash

# copy alacritty config
cp ~/.config/alacritty/alacritty.yml ./.config/alacritty/

# copy i3 config files
cp ~/.config/i3/* ./.config/i3/

# copy polybar config
cp ~/.config/polybar/* ./.config/polybar/

# copy nvim config
cp ~/.config/nvim/init.vim ./.config/nvim/

# copy coc config
cp ~/.config/nvim/coc-settings.json ./.config/nvim/

# copy tmux config
cp ~/.tmux.conf ./

# copy zsh config
cp ~/.zshrc ./

# copy p10k config
cp ~/.p10k.zsh ./

# copy custom scripts
cp ~/.config/custom/* ./.config/custom/

