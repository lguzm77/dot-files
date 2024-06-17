#! /usr/bin/env bash

echo "Starting setup script"

echo "Installing the kitty terminal emulator"
# check if kitty is installed

if ! command -v kitty >&2; then 
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else 
  echo "kitty is already installed"
fi 

echo "Installing the homebrew package manager"
# check if homebrew is installed
if ! command -v brew >&2; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else 
  echo "homebrew is already installed"
fi 

echo "Updating homebrew and installing shell tools"
brew update 
shell_tools=("neovim eza zoxide bat docker ripgrep koekeishiya/formulae/yabai koekeishiya/formulae/skhd fzf kubectl stow")
for tool in "${shell_tools[@]}";
do
  brew install $tool;
done 

echo "Running stow on all modules"
# In stow, each folder is a module containing the desired symlink path to follow
for module in $(ls -d */)/;
do 
  stow $module;
done

echo "Finished setup script"

