# dotfiles

Machine configuration for macOS/Linux using Homebrew, Ansible (including AUR on Arch), and mise for runtime + dotfile management.

## Bootstrapping

1. Clone this repository to `~/.dotfiles`.
2. Run:

```sh
~/.dotfiles/setup.sh
```

`setup.sh` installs Homebrew dependencies, installs mise, applies runtimes/tools from `mise.toml`, applies dotfiles with `mise dotfiles apply`, and then runs the Ansible playbook.

## Runtime/tool management (mise)

Runtime and global CLI versions are managed in `mise.toml`:

- Node.js
- Java
- .NET
- npm global CLIs (for active Node runtime)

Common commands:

```sh
cd ~/.dotfiles
mise trust ~/.dotfiles/mise.toml
mise install
mise dotfiles status
mise dotfiles apply --yes
```

## Dotfiles management (mise dotfiles)

Dotfile mappings are declared in `mise.toml` under `[dotfiles]`.

- Root dotfiles (for example `zshrc`, `gitconfig`, `tmux.conf`) are symlinked to `~/.*`.
- `config/` is applied to `~/.config` with `symlink-each`.
- `local/bin/` is applied to `~/.local/bin` with `symlink-each`.
- VSCode user files under `Library/Application Support/Code/User` are mapped for macOS.

## Linux packages and AUR

Ansible remains the package orchestration path for Linux machine setup/AUR packages via `setup.yaml`.
