# zstyle
zstyle :compinstall filename "${HOME}/.zshrc"
zmodload zsh/complist

# keybindings
bindkey -v
bindkey -M menuselect '^[[Z' reverse-menu-complete

# options
setopt auto_cd
setopt no_beep
setopt interactivecomments

os_type="$(builtin command uname)" || echo "$(tput setaf 1)Unable to determine OS\nCheck your zshrc...$(tput sgr0)"

# Ensure zplug installation
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

# Default functions
fpath+=("${HOME}/.zsh/completion")

# Enable homebrew function discovery
if (($+commands[brew])); then
  fpath+=("$(brew --prefix)/completion/zsh")
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi

# Default source code path (Gets a special folder icon on macOS
cdpath+=($HOME/Developer)

# compinit
autoload -Uz compinit && compinit
autoload -U colors && colors
autoload -U add-zsh-hook
autoload -U +X bashcompinit && bashcompinit

# Source
[ -f ~/.fzf.zsh ]        && source ~/.fzf.zsh
[ -f ~/.cargo/env ]      && source ~/.cargo/env
[ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh

# The following always exist due to dotfile symlink
source "${HOME}/.local/bin/updatePOB.sh"
source "${HOME}/.local/bin/sync-devwork.sh"
source "${HOME}/.local/bin/system-update.sh"
source "${HOME}/.local/bin/register-completions.zsh"
source "${HOME}/.local/bin/security.sh"

# Self Manage
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Load plugins
zplug "lib/completion", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh, as:plugin
zplug "plugins/git", from:oh-my-zsh, as:plugin
zplug "plugins/kops", from:oh-my-zsh, as:plugin
zplug "plugins/minikube", from:oh-my-zsh, as:plugin
zplug "plugins/nomad", from:oh-my-zsh, as:plugin
zplug "plugins/swiftpm", from:oh-my-zsh, as:plugin
zplug "plugins/npm", from:oh-my-zsh, as:plugin
zplug "plugins/ng", from:oh-my-zsh, as:plugin
zplug "plugins/terraform", from:oh-my-zsh, as:plugin
zplug "plugins/vagrant", from:oh-my-zsh, as:plugin
zplug "plugins/vault", from:oh-my-zsh, as:plugin
zplug "plugins/vi-mode", from:oh-my-zsh, as:plugin
zplug "plugins/kind", from:oh-my-zsh, as:plugin
zplug "plugins/helm", from:oh-my-zsh, as:plugin
zplug "plugins/kubectl", from:oh-my-zsh, as:plugin
zplug "plugins/dotnet", from:oh-my-zsh, as:plugin

# Theme
zplug "mafredri/zsh-async", from:github
zplug "chriskempson/base16-shell", from:github
zplug "sowderca/pure", use:pure.zsh, from:github, as:theme

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

# Theme
base16_gruvbox-dark-medium

# Alias
alias ai="gh copilot"
alias cls="clear"
alias vim="nvim"
alias bat="bat --theme gruvbox-dark"
alias dir="ls -lh"
alias del="rm"
alias git="hub"
alias buck="buck2"
alias chatgpt="aichat"
alias powershell="pwsh"
alias pass="read-password"
alias start="open"
alias tmux="env TERM=screen-256color tmux"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias help="tldr"
alias hackernews="clx"

# Add homebrew programs to path.
if (($+commands[brew])); then
  path+=("$(brew --prefix)/bin")
fi

# Add GOPATH binaries to path.
if (($+commands[go])); then
  path+=("$(go env GOPATH)/bin")
fi

# Normal path setup
path+=("/opt/dsc")
path+=("/opt/git-tf")
path+=("/opt/hermes")
path+=("/opt/omi/bin")
path+=("/opt/local/bin")
path+=("/usr/local/sbin")
path+=("${HOME}/.porter")
path+=("${HOME}/.tiup/bin")
path+=("${HOME}/.yarn/bin")
path+=("${HOME}/.jenv/bin")
path+=("${HOME}/.local/bin")
path+=("${HOME}/.fastlane/bin")
path+=("${HOME}/.dotnet/tools")
path+=("${HOME}/.pub-cache/bin")
path+=("${KREW_ROOT:-$HOME/.krew}/bin")
path+=("${HOME}/.config/v-analyzer/bin/")
path+=("${HOME}/.config/yarn/global/node_modules/.bin")

if ! [[ -z $os_type ]]; then
  if [[ $os_type = *"Darwin"* ]]; then
    path+=("${HOME}/Library/Python/3.9/bin")
    path+=("/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Helpers/")
    path+=("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/") 
  fi
fi

export PATH

# NVM / Node.js
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

(($+commands[brew]))  && eval "$(brew shellenv)"
(($+commands[jenv]))  && eval "$(jenv init -)"
(($+commands[rbenv])) && eval "$(rbenv init -)"

eval "$(register-python-argcomplete pipx)"

if [[ -f ~/.go/bin/gocomplete ]]; then
  complete -o nospace -C ~/.go/bin/gocomplete go
fi

[[ -z $os_type ]] && unset os_type
