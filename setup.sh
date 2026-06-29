#!/bin/sh

# Bootstrap this dotfiles repo. This script is intentionally idempotent: it can
# be rerun after a fix and will refresh symlinks without touching real files.

info() {
  printf '%s\n' "==> $*"
}

warn() {
  printf '%s\n' "WARN: $*" >&2
}

have() {
  command -v "$1" >/dev/null 2>&1
}

run() {
  "$@"
  status=$?
  if [ "$status" -ne 0 ]; then
    warn "command failed ($status): $*"
  fi
  return 0
}

script_dir() {
  script=$0
  case "$script" in
    /*) ;;
    *) script=$PWD/$script ;;
  esac

  CDPATH= cd -- "$(dirname -- "$script")" 2>/dev/null && pwd -P
}

DOTFILES_DIR=${DOTFILES_DIR:-$(script_dir)}

if [ "$DOTFILES_DIR" = "$HOME/dotfiles" ]; then
  if [ ! -e "$HOME/.dotfiles" ]; then
    info "moving ~/dotfiles to ~/.dotfiles"
    run mv "$DOTFILES_DIR" "$HOME/.dotfiles"
    DOTFILES_DIR="$HOME/.dotfiles"
  else
    warn "~/.dotfiles already exists; using $DOTFILES_DIR for this run"
  fi
fi

link_path() {
  src=$1
  dest=$2

  if [ ! -e "$src" ]; then
    warn "missing source for $dest: $src"
    return 0
  fi

  if [ -L "$dest" ]; then
    current=$(readlink "$dest" 2>/dev/null)
    if [ "$current" = "$src" ]; then
      info "already linked $dest"
      return 0
    fi

    info "refreshing symlink $dest"
    run rm "$dest"
    run ln -s "$src" "$dest"
    return 0
  fi

  if [ -e "$dest" ]; then
    warn "$dest exists and is not a symlink; leaving it alone"
    return 0
  fi

  info "linking $dest"
  run ln -s "$src" "$dest"
}

brew_path() {
  if [ -x /opt/homebrew/bin/brew ]; then
    printf '%s\n' /opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    printf '%s\n' /usr/local/bin/brew
  elif have brew; then
    command -v brew
  fi
}

use_homebrew() {
  brew=$(brew_path)
  if [ -n "$brew" ]; then
    eval "$("$brew" shellenv 2>/dev/null)" || true
    return 0
  fi

  return 1
}

install_homebrew() {
  if use_homebrew; then
    return 0
  fi

  if [ "$(uname -s)" != "Darwin" ]; then
    return 1
  fi

  if ! have curl; then
    warn "Homebrew is missing and curl is not available to install it"
    return 1
  fi

  info "installing Homebrew"
  installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
  status=$?
  if [ "$status" -ne 0 ] || [ -z "$installer" ]; then
    warn "could not download Homebrew installer"
    return 1
  fi
  /bin/bash -c "$installer"
  status=$?
  if [ "$status" -ne 0 ]; then
    warn "Homebrew install failed ($status)"
  fi
  use_homebrew || warn "Homebrew still was not found after install attempt"
}

brew_install_formula() {
  pkg=$1
  if ! use_homebrew; then
    warn "Homebrew unavailable; cannot install $pkg"
    return 0
  fi

  if brew list --formula "$pkg" >/dev/null 2>&1; then
    info "brew formula already installed: $pkg"
  else
    info "installing brew formula: $pkg"
    run brew install "$pkg"
  fi
}

brew_install_cask() {
  pkg=$1
  if ! use_homebrew; then
    warn "Homebrew unavailable; cannot install cask $pkg"
    return 0
  fi

  if brew list --cask "$pkg" >/dev/null 2>&1; then
    info "brew cask already installed: $pkg"
  else
    info "installing brew cask: $pkg"
    run brew install --cask "$pkg"
  fi
}

install_mac_tools() {
  if ! xcode-select -p >/dev/null 2>&1; then
    info "requesting Xcode command line tools install"
    run xcode-select --install
  fi

  install_homebrew

  for pkg in lynx pandoc jrnl bash-completion mdcat mdless tldr exiftool glow tmux git-lfs jq coreutils; do
    brew_install_formula "$pkg"
  done

  for pkg in quicklook-json basictex; do
    brew_install_cask "$pkg"
  done
}

install_linux_tools() {
  if have apt-get; then
    sudo_cmd=
    if have sudo; then
      sudo_cmd=sudo
    fi

    info "installing Linux packages with apt-get"
    run $sudo_cmd apt-get update
    run $sudo_cmd apt-get install -y git curl zsh vim tmux perl lynx pandoc jq tldr
  else
    warn "no supported Linux package manager found"
  fi
}

install_oh_my_zsh() {
  if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    info "oh-my-zsh already installed"
    return 0
  fi

  if ! have curl; then
    warn "oh-my-zsh is missing and curl is not available to install it"
    return 0
  fi

  info "installing oh-my-zsh"
  installer=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
  status=$?
  if [ "$status" -ne 0 ] || [ -z "$installer" ]; then
    warn "could not download oh-my-zsh installer"
    return 0
  fi

  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$installer"
  status=$?
  if [ "$status" -ne 0 ]; then
    warn "oh-my-zsh install failed ($status)"
  fi
}

install_tools() {
  case "$(uname -s)" in
    Darwin) install_mac_tools ;;
    Linux) install_linux_tools ;;
    *) warn "unknown OS; skipping package install" ;;
  esac

  install_oh_my_zsh
}

link_dotfiles() {
  link_path "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  link_path "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
  link_path "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
  link_path "$DOTFILES_DIR/shell/aliases.sh" "$HOME/.sh_aliases"
  link_path "$DOTFILES_DIR/shell/functions.bash" "$HOME/.bash_fns"
  link_path "$DOTFILES_DIR/shell/functions.zsh" "$HOME/.zsh_fns"
  link_path "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
  link_path "$DOTFILES_DIR/vim/.vim" "$HOME/.vim"
  link_path "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  link_path "$DOTFILES_DIR/git/ignore" "$HOME/.gitignore"
  link_path "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

link_bin() {
  if [ ! -d "$HOME/bin" ]; then
    info "creating ~/bin"
    run mkdir -p "$HOME/bin"
  fi

  for src in "$DOTFILES_DIR"/bin/*; do
    [ -f "$src" ] || continue
    link_path "$src" "$HOME/bin/$(basename "$src")"
  done
}

link_oh_my_zsh_theme() {
  if [ -d "$HOME/.oh-my-zsh/themes" ]; then
    link_path "$DOTFILES_DIR/zsh/justin.zsh-theme" "$HOME/.oh-my-zsh/themes/justin.zsh-theme"
  else
    warn "oh-my-zsh themes dir missing"
  fi
}

install_terminfo() {
  if have tic; then
    run tic "$DOTFILES_DIR/terminal/xterm-256color-italic.terminfo"
  else
    warn "tic is not available; skipping italic terminfo install"
  fi
}

info "using dotfiles from $DOTFILES_DIR"
if [ "${DOTFILES_SKIP_TOOL_INSTALL:-}" = 1 ]; then
  info "skipping tool install checks"
else
  install_tools
fi
link_dotfiles
link_bin
link_oh_my_zsh_theme
install_terminfo
info "dotfiles setup complete"
