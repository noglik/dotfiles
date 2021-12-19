#!/bin/bash

# copy alacritty config
cp ~/.config/alacritty/alacritty.yml ./.config/alacritty/

# copy i3 config files
cp ~/.config/i3/* ./.config/i3/

# copy nvim config
cp ~/.config/nvim/init.vim ./.config/nvim/

# copy tmux config
cp ~/.tmux.conf ./

# copy zsh config
cp ~/.zshrc ./

# copy xinit
cp ~/.xinitrc ./

# copy xmodmap
cp ~/.Xmodmap ./
