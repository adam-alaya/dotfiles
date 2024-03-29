#!/bin/bash

# setup.sh
# Symlink dotfiles to the correct locations
# Commented out files have been omitted as to not mess with current configs. uncomment to include them in them
DIR=$HOME/dotfiles
DOTFILES=(
  ".config/alacritty"
  ".config/dunst"
  ".config/picom"
  ".config/tmux"
  ".config/qtile"
  ".config/rofi"
  # ".zshrc"
  ".ideavimrc"
  # ".config/nvim"
)
# ln -sf .config/cvim ~/.config/cvim
for dot in "${DOTFILES[@]}"; do
    # rm -rf "${HOME}/$dot"
    ln -sf "${DIR}/${dot}" "${HOME}/${dot}"
done
