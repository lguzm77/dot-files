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
}

shell() {
  echo "Setting up shell environment"

  echo "Setting relevant environment variables"
  # Create a symlink between $PWD/.zprofile and $HOME/.zprofile
  ln -s "$PWD/.zprofile" "$HOME/.zprofile"
  source "$PWD/.zprofile"
  stow zsh

}


symlinks () {
  echo "Setting up symlinks using stow"
  stow .
}

git () {
  echo "Setting up .gitconfig file"
  
  # Ask for an email
  local github_email
  local github_username
  read -p "Enter your github email account" github_email
  read -p "Enter your github username" github_username

  # Populate .gitconfig file


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
  symlinks)
    symlinks
    ;;
  git)
    git
    ;;
  *) 
    all
    ;;
esac 


