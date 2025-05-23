# zstyle
zstyle :compinstall filename "${HOME}/.zshrc"
zmodload zsh/complist

# keybindings
bindkey -v
bindkey -M menuselect '^[[Z' reverse-menu-complete

# options
setopt interactivecomments
setopt no_beep

# compinit
autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U add-zsh-hook

[[ -f ~/.zplug/init.zsh ]] || return

# Ensure zplug installation
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Source
source "${HOME}/.fzf.zsh"
source "${HOME}/.cargo/env"
source "${HOME}/.zplug/init.zsh"
source "${HOME}/.local/bin/sync-devwork.sh"
source "${HOME}/.local/bin/system-update.sh"
source "${HOME}/.local/bin/register-completions.zsh"
source "${HOME}/.local/bin/security.sh"
source "${HOME}/.iterm2_shell_integration.zsh"

# Load plugins
zplug "lib/completion", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh, as:plugin
zplug "plugins/git", from:oh-my-zsh, as:plugin
zplug "plugins/kops", from:oh-my-zsh, as:plugin
zplug "plugins/minikube", from:oh-my-zsh, as:plugin
zplug "plugins/nomad", from:oh-my-zsh, as:plugin
zplug "plugins/npm", from:oh-my-zsh, as:plugin
zplug "plugins/terraform", from:oh-my-zsh, as:plugin
zplug "plugins/vagrant", from:oh-my-zsh, as:plugin
zplug "plugins/vault", from:oh-my-zsh, as:plugin
zplug "plugins/vi-mode", from:oh-my-zsh, as:plugin

# Theme
zplug "mafredri/zsh-async", from:github
zplug "sowderca/pure", use:pure.zsh, from:github, as:theme


# Completions
compctl -K _dotnet_zsh_complete dotnet

# Install packages that have not yet been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  else
    echo
  fi
fi

# Load zplug
zplug load

# Alias
alias cls=clear
alias vim=nvim
alias dir="ls -l"
alias del=rm
alias git=hub
alias powershell=pwsh
alias pass="read-password"
alias start=open
alias tmux="env TERM=screen-256color tmux"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# PATH setup
path+=("$(go env GOPATH)/bin")
path+=("${KREW_ROOT:-$HOME/.krew}/bin")
path+=("${HOME}/.fastlane/bin")
path+=("${HOME}/.porter")
path+=("${HOME}/.dotnet/tools")
path+=("/usr/local/sbin")

if which ruby >/dev/null && which gem >/dev/null; then
    path+=("$(ruby -rubygems -e 'puts Gem.user_dir')/bin")
fi

export PATH

# Settings for base16
BASE16_SHELL="$HOME/.config/base16-shell"
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# NVM / Node.js
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# RBENV & JENV
eval "$(jenv init -)"
eval "$(rbenv init -)"
