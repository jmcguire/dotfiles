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

export PS1="\[\033[G\][\h \w] $ "
export EDITOR=vi

export PATH=$HOME/bin:/usr/local/MM/bin:$PATH:$HOME/bin:$HOME/perl5/bin

export DEFAULT_LEAF_PORT=1500
export EACCRED_DIR=$HOME
export LEAF_LIB_DIR=$HOME/leaf/lib
export CATALYST_CONFIG_LOCAL_SUFFIX=dev_$USER

export PERL_LOCAL_LIB_ROOT="/home/jmcguire/lib/perl5"
export PERL_MB_OPT="--install_base /home/jmcguire/lib/perl5"
export PERL_MM_OPT="INSTALL_BASE=/home/jmcguire/lib/perl5"
export PERL5LIB=/usr/local/MM/lib/perl5:$HOME/leaf/lib/:$HOME/lib/perl5/:$HOME/lib/perl5/lib/perl5/i686-linux:$HOME/lib/perl5/lib/perl5

##
## adjust the way bash works
##

shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize
set -o ignoreeof
shopt -s no_empty_cmd_completion
shopt -s lithist

