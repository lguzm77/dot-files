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
}

shell() {
  echo "Setting relevant environment variables"

  # Create a symlink between $PWD/.zprofile and $HOME/.zprofile
  ln -s "$PWD/.zprofile" "$HOME/.zprofile"
  source "$PWD/.zprofile"

}

editor () {
  echo "Editor not implemented"
}

symlinks () {
  echo "Setting up symlinks"
  stow .
}

all() {
  shell
  dependencies
  editor
  symlinks
}


case "$1" in
  dependencies) 
    dependencies
    ;;
  shell)
    shell
    ;;
  editor) 
    editor
    ;;
  *) 
    all
    ;;
esac 


