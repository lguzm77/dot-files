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
development_tools=("minikube elixir neovim docker kubectl fnm graphviz python") # fnm stands for fast node manager
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

# Most of my config files (nvim and kitty for now) live in the .config folder
stow ./config


echo "Finished installing tools, setting up home directory folders and tools"
cd $HOME

# TODO: can you add colors to the echo lines?
echo "Setting up Python environment for diagrams"

function installDiagrams(){
mkdir architecture-diagrams


# Setup a new python3 virtual environment
cd ./architecture-diagrams && python3 -m venv diagrams-pyenv

# Install all necessary tooling
source diagrams-pyenv/bin/activate
pip3 install diagrams

#return to the root directory
cd ..
}

# CHeck if the directory exists
if [ ! -d "architecture-diagrams" ]; then
  installDiagrams
  echo "architecture-diagrams directory created and diagram tooling installed"
else
  # if the directory exists, we can assume that the necessary tooling is already installed. 
  # This script is meant to run in a new computer
  echo "Directory architecture-diagrams already exists"
fi


echo "Setting up Mermaid diagrams local environment"

if ! command -v mmdc >&2; then
  npm install -g @mermaid-js/mermaid-cli
  mkdir mermaid-diagrams
  echp "Mermaid tooling installed and mermaid-diagrams directory created"
else
  echo "Mermaid is already installed"
fi
# Usage mmdc -i input.mmd -o output.png -t dark -b transparent

echo "Finished setup script"

