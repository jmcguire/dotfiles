#!/bin/sh

## execute this to setup your environment

## by default our dotfiles dir appears as a non-hidden dir, lets change that
if [ -d ~/dotfiles ]; then
  echo "hiding .dotfiles/"
  mv ~/dotfiles ~/.dotfiles
fi

## save our current bash_profile
if [ -f ~/.bash_profile ]; then
  echo "saving .bash_profile to .bash_local"
  echo "## copied from old .bash_profile" >>~/.bash_local
  cat ~/.bash_profile >>~/.bash_local
  rm ~/.bash_profile
else
  echo "creating .bash_local"
  touch ~/.bash_local
fi

## backup our current zshrc
if [ -f ~/.zshrc ]; then
  echo "saving .zshrc to .zshrc_old"
  echo "## copied from old .zshrc" >>~/.zshrc_old
  cat ~/.zshrc >>~/.zshrc_old
  rm ~/.zshrc
fi

## link my dotfiles
for filename in .bash_profile .sh_aliases .bash_fns .vimrc .vim/ .gitconfig .zshrc; do
  if [ ! -e ~/$filename ]; then
    echo "linking dotfile $filename"
    ln -s ~/.dotfiles/$filename ~/$filename
  else
    echo "dotfile $filename already exists, skipping"
  fi
done

## special handling for .gitignore
if [ ! -e ~/.gitignore ]; then
  echo "linking dotfile .gitignore"
  ln -s ~/.dotfiles/.my.gitignore ~/.gitignore
else
  echo "dotfile .gitignore already exists, skipping"
fi

## install justin theme in oh-my-zsh
if [ -e ~/.oh-my-zsh/themes/ ]; then
  echo "linking justin theme in .oh-my-zsh/themes/"
  ln -s ~/.dotfiles/justin.zsh-theme ~/.oh-my-zsh/themes/
else
  echo "oh-my-zsh themes dir missing. is oh-my-zsh installed?"
fi

## setup the .bashrc file
grep -q "bash_profile" ~/.bashrc
if [ $? -eq 0 ]; then
  echo "sourcing .bash_profile in .bashrc"
  cat >> ~/.bashrc <<EOF

## source my global definitions
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

EOF
fi

## setup the bin/ directory
if [ ! -d ~/bin ]; then
  echo "creating the bin/ directory"
  mkdir ~/bin/
fi

## linking my common scripts
for filename in get-perl-function intersection perl-sub-info pm_info.pl rename.pl; do
  if [ ! -e ~/bin/$filename ]; then
    echo "linking script $filename"
    ln -s ~/.dotfiles/bin/$filename ~/bin/$filename
  fi
done

## make italics work
tic ~/.dotfiles/xterm-256color-italic.terminfo

