export CLICOLOR=1
export CLICOLOR_FORCE=1

export GOPATH="${HOME}/.go"
export GO111MODULE="auto"

export NVM_DIR="${HOME}/.nvm"
export NVIM_TUI_ENABLE_TRUE_COLOR=1

export TERMINFO="${HOME}/.terminfo"

export HOMEBREW_BUNDLE_FILE="${HOME}/.dotfiles/Brewfile"

export NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED=true

if (($+commands[rustc])); then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

[[ -d "/Library/Java/JavaVirtualMachines/graalvm-25.jdk/Contents/Home/" ]] && export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-25.jdk/Contents/Home/"
