_dotfiles_source="${(%):-%N}"
while [[ -L "$_dotfiles_source" ]]; do
  _dotfiles_dir="${_dotfiles_source:h}"
  _dotfiles_source="$(readlink "$_dotfiles_source")"
  [[ "$_dotfiles_source" = /* ]] || _dotfiles_source="$_dotfiles_dir/$_dotfiles_source"
done
export DOTFILES_DIR="${DOTFILES_DIR:-${_dotfiles_source:h:h}}"
unset _dotfiles_source _dotfiles_dir

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH

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
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh" # has to be last in this paragraph
fi

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
if [[ -f "$DOTFILES_DIR/shell/aliases.sh" ]]
then
  . "$DOTFILES_DIR/shell/aliases.sh"
fi

# and the functions
if [[ -f "$DOTFILES_DIR/shell/functions.zsh" ]]
then
  . "$DOTFILES_DIR/shell/functions.zsh"
fi

# source my local/custom definitions
# (this should always be last)
if [ -f ~/.zshrc_local ]; then
  . ~/.zshrc_local
fi

