## execute this to setup your environment

## save our current settings
if [ -f ~/.bash_profile ]; then
  cat ~/.bash_profile >>~/.bash_local
else
  touch ~/.bash_local
fi

ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_fns ~/.bash_fns
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.my.gitignore ~/.gitignore

## setup the .bashrc file
cat >> ~/.bashrc <<EOF

## source my global definitions
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

EOF

## by default our dotfiles dir appears as a non-hidden dir, lets change that
if [ -d ~/dotfiles ]; then
  mv ~/dotfiles ~/.dotfiles
fi

