#! /usr/bin/env bash
set -o errexit # stop script if error is raised.
set -o nounset # raise an error if a variable is unset.

echo "Starting setup script\n"

echo "Installing the homebrew package manager\n"
# check if homebrew is installed
if ! command -v brew >&2; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else 
  echo "homebrew is already installed\n"
fi 

#[ is an alternative for the test command 
# [[ is a shell keyword, alternative for test 

echo "Installing homebrew packages\n"
xargs brew install < "$HOME/dot-files/homebrew/leaves.txt"
# Install wezterm, does not appear in leaves.txt 
echo "Installing wezterm"
brew install --cask wezterm

# Install aerospace, does not appear in leaves.txt
echo "Installing aerospace"
brew install --cask nikitabobko/tap/aerospace

echo "Running stow on cwd\n"
stow .

echo "Finished installing tools, setting up home directory folders and tools"
cd "$HOME"

# TODO: can you add colors to the echo lines?
echo "Setting up Python environment for diagrams\n"

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

# Create a directory where all your projects will be placed
if [[ ! -d "projects" ]]; then
  mkdir projects
  echo "Created projects directory"
else
  echo "projects directory already exists" 
fi 

echo "Finished setup script"

