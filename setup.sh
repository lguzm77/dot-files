#! /usr/bin/env bash

dependencies(){
  echo "Installing dependencies"

  if ! command -v brew > /dev/null ; then 
    echo "Homebrew not found, installing"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install Homebrew
  fi 

  # Install all packages 
  xargs brew install < "$PWD/homebrew/leaves.txt"

  # Casks have a slightly different syntax
  brew install --cask wezterm 
  # Install window manager
  brew install --cask nikitabobko/tap/aerospace

  #pywal16
  pipx install pywal16
}

shell() {
  echo "Setting up shell environment"

  echo "Setting relevant environment variables"
  # Create a symlink between $PWD/.zprofile and $HOME/.zprofile
  ln -s "$PWD/.zprofile" "$HOME/.zprofile"
  source "$PWD/.zprofile"
  stow zsh

}

render () {
  echo "Rendering template files"
  local github_username
  local github_name

  read -r -p "Enter your github account email: " github_username
  read -r -p "Enter your github account name: " github_name

  sed "s/{ { GITHUB_EMAIL } }/$github_username/g" ./git/.gitconfig.template |
    sed "s/{ { GITHUB_NAME } }/$github_name/g" > ./git/.gitconfig
  
}

symlinks () {
  echo "Setting up symlinks using stow"
  stow .
}

all() {
  shell
  dependencies
  render
  symlinks
}


case "$1" in
  dependencies) 
    dependencies
    ;;
  shell)
    shell
    ;;
  symlinks)
    symlinks
    ;;
  render) render;;
  *) 
    all
    ;;
esac 


