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

function installUsingHomebrew(){
  local packageNames=("$@") # Create a local copy of the array 
  echo $packageNames

  for packageName in "${packageNames[@]}";
  do 
    brew install $packageName
  done 
}

echo "Installing development tools using homebrew"
development_tools=("minikube elixir neovim docker kubectl fnm graphiz python") # fnm stands for fast node manager
installUsingHomebrew "${development_tools[@]}"
  
echo "Installing shell tools using homebrew"
shell_tools=("eza zoxide bat ripgrep koekeishiya/formulae/yabai koekeishiya/formulae/skhd fzf stow powerlevel10k") 
installUsingHomebrew "${shell_tools[@]}"

echo "Running stow on all modules"
# In stow, each folder is a module containing the desired symlink path to follow
for module in $(ls -d */)/;
do 
  stow $module;
done

echo "Finished setup script"

