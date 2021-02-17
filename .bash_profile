#!/bin/bash
 
# two basic commands, used everywhere in my setup

unalias quietly 2> /dev/null
quietly() { "$@" > /dev/null 2>&1; }
quietly unalias have
have() { type "$@" > /dev/null 2>&1; } # for use in a bash IF statement

# Get the aliases and functions

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
# Automatically highlight matches with grep
export GREP_OPTIONS=--color=always
export LESS=-r
export PERL_UNICODE=AS
export LC_COLLATE="C"
#export PS1="\[\033[G\][\h \w] $ "
#export PS1="[\h \w] $ "
#export PS1="\e[0;35m[\e[0;32m\h \e[0;36m\w\e[0;35m] $\e[m "
export PS1="\[\e[31;1m\]\u@\h\[\e[m\]:\[\e[32;1m\]\w\[\e[0m\] > "
export EDITOR=vim
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export PATH=$HOME/bin:$HOME/perl5/bin/:$PATH

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

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

## source my local/custom definitions
## (this should always be last)
if [ -f ~/.bash_local ]; then
  . ~/.bash_local
fi

