#! /usr/bin/env bash
#Personal macos setup script

# move .zshrc (which is inside this repo) to ~/

# check if homebrew is installed
which -s brew # Checks if the executable is found
# $? is the most recent foreground pipeline exit status 
if [[$? != 0]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi 

# Neovim requirement
#install fuzzy finder
if  [-f './fzf/' ]; then 
  echo "Installing fuzzyfinder fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf.zsh
fi  

echo "installing zoxide for cd replacement"
brew install zoxide

# TODO: Set up an array of strings with the dependencies that neovim has
# loop through the array and execute `brew install`
echo "Installing neovim dependencies"
brew install ripgrep
# install bat
brew install bat

# install zoxide
# install neovim
#
# install docker
# install yabai
brew install koekeishiya/formulae/yabai
# install skhd, for keybindings 
brew install koekeishiya/formulae/skhd 
# clone all my config repos and move them to .config/
