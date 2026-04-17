export CLICOLOR=1
export CLICOLOR_FORCE=1
export GO111MODULE="auto"
export GOPATH="${HOME}/.go"
export NVM_DIR="${HOME}/.nvm"
export BUN_INSTALL="${HOME}/.bun"
export WASMER_DIR="${HOME}/.wasmer"
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export TERMINFO="${HOME}/.terminfo"
export NUGET_CREDENTIALPROVIDER_SESSIONTOKENCACHE_ENABLED=true

if (($+commands[rustc])); then
  . "${HOME}/.cargo/env"
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

[[ -d "/Library/Java/JavaVirtualMachines/graalvm-25.jdk/Contents/Home/" ]] &&  export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-25.jdk/Contents/Home/"
