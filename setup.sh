## execute this to setup your environment

## save our current settings
if [ -f ~/.bash_profile ]; then
  echo "saving .bash_profile to .bash_local"
  cat ~/.bash_profile >>~/.bash_local
else
  echo "creating .bash_local"
  touch ~/.bash_local
fi

echo "creating dot aliases"
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_fns ~/.bash_fns
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim/ ~/.vim/
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.my.gitignore ~/.gitignore

## setup the .bashrc file
echo "sourcing .bash_profile in .bashrc"
cat >> ~/.bashrc <<EOF

## source my global definitions
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

EOF

## by default our dotfiles dir appears as a non-hidden dir, lets change that
if [ -d ~/dotfiles ]; then
  echo "hiding .dotfiles/"
  mv ~/dotfiles ~/.dotfiles
fi

## setup the bin/ directory
if [ ! -d ~/bin ]; then
  echo "creating the bin/ directory"
  mkdir ~/bin/
fi

