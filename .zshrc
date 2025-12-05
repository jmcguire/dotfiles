export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=usr/local/go/bin::$PATH
export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.

export CASE_SENSITIVE="true" # case-sensitive completion.
export HYPHEN_INSENSITIVE="false" # _ and - will be interchangeable.
export COMPLETION_WAITING_DOTS="true" # display red dots whilst waiting for completion.
export HIST_STAMPS="yyyy-mm-dd"
export HISTORY_IGNORE="(jrnl *|jrnl)"
# DISABLE_MAGIC_FUNCTIONS="true" #if pasting URLs and other text is messed up.
export TERM=xterm-256color-italic

# on-my-zsh stuff
zstyle ':omz:update' mode reminder  # remind me when it's time to update
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
ZSH_THEME="justin"
source $ZSH/oh-my-zsh.sh # has to be last in this paragraph

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='vim'

setopt GLOB_COMPLETE
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

# and the functions
if [[ -f ~/.zsh_fns ]]
then
  . ~/.zsh_fns
fi

function zshaddhistory() {
    emulate -L zsh
    if ! [[ "$1" =~ "/^jrnl/" ]] ; then
        print -sr -- "${1%%$'\n'}"
        fc -p
    else
        return 1
    fi
}

# source my local/custom definitions
# (this should always be last)
if [ -f ~/.zshrc_local ]; then
  . ~/.zshrc_local
fi


