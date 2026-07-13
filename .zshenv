export CLICOLOR=1
export CLICOLOR_FORCE=1

export GOPATH="${HOME}/.go"
export GO111MODULE="auto"

export NVIM_TUI_ENABLE_TRUE_COLOR=1

export TERMINFO="${HOME}/.terminfo"

export HOMEBREW_BUNDLE_FILE="${HOME}/.dotfiles/Brewfile"

export NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED=true

if (($+commands[nvim])); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

export OPENER=$EDITOR

if (($+commands[rustc])); then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi
