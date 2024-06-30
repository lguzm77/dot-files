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

echo "Updating homebrew"
brew update 

echo "Installing all development tools"
development_tools=("minikube elixir neovim docker kubectl elixir")
for tool in "${development_tools[@]}";
do 
  brew install $tool;
done 

echo "Installing all shell tools"
shell_tools=("eza zoxide bat ripgrep koekeishiya/formulae/yabai koekeishiya/formulae/skhd fzf stow jandedobbeleer/oh-my-posh/oh-my-posh")

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
# TODO: setup git credentials and clone all repos

echo "Finished setup script"

