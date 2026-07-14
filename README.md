# dotfiles

Machine configuration for macOS/Linux (including WSL) using Homebrew, Ansible (including AUR on Arch), and mise for runtime + dotfile management.

## Bootstrapping

1. Clone this repository to `~/.dotfiles`.
2. Run (from any shell):

```sh
bash ~/.dotfiles/setup.sh
```

`setup.sh` is phase-driven and idempotent. It runs:

1. `bootstrap` (base tooling + Homebrew)
2. `packages` (Brewfile)
3. `toolchains` (`mise trust/install`)
4. `dotfiles` (`mise dotfiles apply`)
5. `config-management` (Ansible)

Useful modes:

```sh
# preflight only (no changes)
bash ~/.dotfiles/setup.sh --check

# preview actions
bash ~/.dotfiles/setup.sh --dry-run

# run a single phase
bash ~/.dotfiles/setup.sh --phase dotfiles

# run from a phase onward
bash ~/.dotfiles/setup.sh --from-phase toolchains

# resume after a failed run
bash ~/.dotfiles/setup.sh --resume
```

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

## Containerized CachyOS preflight testing

For quick CI/local validation without a full VM:

```sh
docker build -f Dockerfile.cachyos -t dotfiles-cachyos-test .
docker run --rm dotfiles-cachyos-test
```

Override image if needed:

```sh
docker build -f Dockerfile.cachyos \
  --build-arg CACHYOS_IMAGE=ghcr.io/cachyos/cachyos:latest \
  -t dotfiles-cachyos-test .
```

Vagrant docker target:

```sh
vagrant up cachyos-docker --provider=docker
```
