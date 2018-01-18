# vim keybindings
bindkey -v

# zstyle
zstyle :compinstall filename "$HOME/.zshrc"

# options
setopt interactivecomments

# compinit
autoload -Uz compinit
autoload -U colors
autoload -U add-zsh-hook
colors
compinit

# Ensure zplug installation
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Source zplug
source ~/.zplug/init.zsh

# Load plugins
zplug "plugins/git", from:oh-my-zsh, as:plugin
zplug "plugins/vi-mode", from:oh-my-zsh, as:plugin
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "lib/completion", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh

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
alias git=hub
alias pip=pip2
alias powershell=pwsh

# Env setup
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/Workspace/go"
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export CLICOLOR=1
export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.fastlane/bin:$PATH"
export RUST_SRC_PATH="$HOME/.multirust/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src"

# Sync script
function sync-devwork() {
	sh $HOME/.dotfiles/local/bin/sync-devwork
}

function system-update() {
	sh $HOME/.dotfiles/local/bin/system-update
}

# Settings for base16
BASE16_SHELL="$HOME/.config/base16-shell"
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NVM / Node.js
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# RBENV
eval "$(rbenv init -)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Workspace/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/Workspace/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Workspace/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/Workspace/google-cloud-sdk/completion.zsh.inc"; fi
