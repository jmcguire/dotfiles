export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=usr/local/go/bin::$PATH
export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.

ZSH_THEME="justin"

export CASE_SENSITIVE="true" # case-sensitive completion.
export HYPHEN_INSENSITIVE="false" # _ and - will be interchangeable.
export COMPLETION_WAITING_DOTS="true" # display red dots whilst waiting for completion.
export HIST_STAMPS="yyyy-mm-dd"
export HISTORY_IGNORE="(jrnl *|jrnl)"
# DISABLE_MAGIC_FUNCTIONS="true" #if pasting URLs and other text is messed up.
export TERM=xterm-256color-italic

zstyle ':omz:update' mode reminder  # remind me when it's time to update

plugins=(git colored-man-pages colorize)

source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='vim'

setopt APPEND_HISTORY
setopt GLOB_COMPLETE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS


# two basic commands, used everywhere in my setup

unalias quietly 2>/dev/null
function quietly() { "$@" > /dev/null 2>&1; }
quietly unalias have
function have() { type "$@" > /dev/null 2>&1; } # for use in a bash IF statement

# Get the aliases, which luckily are the same format in bash as zsh

if [[ -f ~/.sh_aliases ]]
then
  . ~/.sh_aliases
fi

# quick_weather # this can be slow

