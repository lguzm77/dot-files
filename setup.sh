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
  echo "Not implemented"

}

editor () {
  echo "Editor not implemented"
}

all() {
  shell
  dependencies
  editor
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


