# zstyle
zmodload zsh/complist
zstyle :compinstall filename "${HOME}/.zshrc"

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

if ! [[ -z $os_type ]]; then
  if ! [[ $os_type = *"Darwin"* ]]; then
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Enable homebrew function discovery
if (($+commands[brew])); then
  fpath+=("$(brew --prefix)/completion/zsh")
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi

# Default source code paths (Developer gets a special folder icon on macOS
test -d ~/Scripts/  || mkdir -p "${HOME}/Scripts"
test -d ~/Developer || mkdir -p "${HOME}/Developer"

cdpath+=($HOME/Developer)

# compinit
autoload -U add-zsh-hook
autoload -U colors && colors
autoload -Uz compinit && compinit
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
zplug "lib/history", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh

zplug "plugins/ng",        from:oh-my-zsh, as:plugin
zplug "plugins/git",       from:oh-my-zsh, as:plugin
zplug "plugins/npm",       from:oh-my-zsh, as:plugin
zplug "plugins/kind",      from:oh-my-zsh, as:plugin
zplug "plugins/kops",      from:oh-my-zsh, as:plugin
zplug "plugins/helm",      from:oh-my-zsh, as:plugin
zplug "plugins/vault",     from:oh-my-zsh, as:plugin
zplug "plugins/nomad",     from:oh-my-zsh, as:plugin
zplug "plugins/docker",    from:oh-my-zsh, as:plugin
zplug "plugins/dotnet",    from:oh-my-zsh, as:plugin
zplug "plugins/swiftpm",   from:oh-my-zsh, as:plugin
zplug "plugins/vagrant",   from:oh-my-zsh, as:plugin
zplug "plugins/vi-mode",   from:oh-my-zsh, as:plugin
zplug "plugins/kubectl",   from:oh-my-zsh, as:plugin
zplug "plugins/minikube",  from:oh-my-zsh, as:plugin
zplug "plugins/terraform", from:oh-my-zsh, as:plugin

zplug "junegunn/fzf", use:"shell/*.zsh", defer:2

# Theme
zplug "mafredri/zsh-async",        from:github
zplug "chriskempson/base16-shell", from:github

# Custom fork
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
if ! [[ -z $os_type ]]; then
  if ! [[ $os_type = *"Darwin"* ]]; then
    base16_gruvbox-dark-hard
    export BASE16_THEME=gruvbox-dark-hard
  else
    base16_gruvbox-dark-medium
    export BASE16_THEME=gruvbox-dark-medium
  fi
fi

# Alias
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ai="gh copilot"
alias cls="clear"
alias bat="bat --theme gruvbox-dark"
alias help="tldr"
alias buck="buck2"
alias powershell="pwsh"
alias hackernews="clx"

# TODO: idk if this is needed....
alias tmux="env TERM=screen-256color tmux"

# An explicit check is needed here since git is used for configuration.
(($+commands[hub])) &&  alias git="hub"

# Explicitly check for neovim
(($+commands[nvim])) && alias vim="nvim"


if ! [[ -z $os_type ]]; then
  if ! [[ $os_type = *"Darwin"* ]]; then
    alias ls="ls --color=always"
    alias less="less --use-color"
    alias vdir="vdir --color=always"
    alias grep="grep --color=always"
    alias meld="org.gnome.meld"
    # Wayland use only
    if ! [[ -z $XDG_SESSION_TYPE ]]; then
      if [[ $XDG_SESSION_TYPE = "x11" ]]; then
        alias pbcopy="xclip"
        alias pbpaste="xclip -o"
      elif [[ $XDG_SESSION_TYPE = "wayland" ]]; then
        alias pbcopy="wl-copy"
        alias pbpaste="wl-paste"
      fi
    fi
  fi
fi

# Add homebrew programs to path.
if (($+commands[brew])); then
  path+=("$(brew --prefix)/bin")
fi

# Add GOPATH binaries to path.
if (($+commands[go])); then
  path+=("$(go env GOPATH)/bin")
fi

if (($+commands[gem])); then
  gem_env="$(gem environment gempath)"
  gem_paths=("${(s/:/)gem_env}")
  for gem_path in $gem_paths; do
    if [[ -d "${gem_path}/bin" ]]; then
      path+=("${gem_path}/bin")
    fi
  done
fi

# Normal path setup
path+=("/opt/dsc")
path+=("/opt/git-tf")
path+=("/opt/hermes")
path+=("/opt/omi/bin")
path+=("/opt/local/bin")
path+=("/usr/local/sbin")

# Home path setup.
path+=("${HOME}/.porter")
path+=("${HOME}/.tiup/bin")
path+=("${HOME}/.yarn/bin")
path+=("${HOME}/.jenv/bin")
path+=("${HOME}/.cargo/bin")
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

(($+commands[brew])) && eval "$(brew shellenv)"
(($+commands[mise])) && eval "$(mise activate zsh --shims)"

eval "$(register-python-argcomplete pipx)"

if [[ -f ~/.go/bin/gocomplete ]]; then
  complete -o nospace -C ~/.go/bin/gocomplete go
fi

[[ -z $os_type ]] && unset os_type
