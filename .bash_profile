# Get the aliases and functions
#if [ -f ~/.bashrc ]; then
#	. ~/.bashrc
#fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ -f ~/.bash_fns ]; then
  . ~/.bash_fns
fi

##
## exports
##

export HISTCONTROL=erasedups

#export PS1="\[\033[G\][\h \w] $ "
export PS1="[\h \w] $ "
export EDITOR=vi

export PATH=$HOME/bin:$PATH

##
## adjust the way bash works
##

shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize
set -o ignoreeof
shopt -s no_empty_cmd_completion
shopt -s lithist
#shopt -s globstar

## source my local/custom definitions
## (this should always be last)
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

