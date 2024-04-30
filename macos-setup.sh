#! /usr/bin/sh bash
#Personal macos setup script

# move .zshrc to ~/

which -s brew # Checks if the executable is found
# $? is the most recent foreground pipeline exit status 
if [[$? != 0]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi 

#install fuzzy finder
if  [-f './fzf/' ]; then 
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf.zsh
fi  

# install neovim
# Install ripgrep
# install docker
# install bat
# install zoxide
# clone all my config repos and move them to .config/
