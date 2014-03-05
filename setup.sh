## execute this to setup your environment

ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_fns ~/.bash_fns
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

## setup the .bashrc file
cat >> ~/.bashrc <<EOF

## source my global definitions
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

## source my local/custom definitions
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

EOF

