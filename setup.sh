#!/usr/bin/env bash

if [ -z "${BASH_VERSION:-}" ]; then
  if command -v bash >/dev/null 2>&1; then
    exec bash "$0" "$@"
  fi
  echo "ERROR: bash is required to run setup.sh." >&2
  exit 1
fi

set -euo pipefail

readonly DOTFILES_DIR="$HOME/.dotfiles"
readonly BREW_FILE="$DOTFILES_DIR/Brewfile"
readonly REQUIREMENTS_FILE="$DOTFILES_DIR/requirements.yml"
readonly PLAYBOOK_FILE="$DOTFILES_DIR/setup.yaml"
readonly CHECKPOINT_FILE="$DOTFILES_DIR/.setup-state"
readonly INVENTORY_DIR="$DOTFILES_DIR/.ansible"
readonly INVENTORY_FILE="$INVENTORY_DIR/inventory.ini"
readonly ANSIBLE_LOCAL_ROLES="$HOME/.ansible/roles"
readonly ANSIBLE_LOCAL_PLUGINS="$HOME/.ansible/plugins/callback"

readonly PHASES=(
  "bootstrap"
  "packages"
  "toolchains"
  "dotfiles"
  "config-management"
)

os_type="$(uname -s)"
is_wsl=false
if [[ "$os_type" == "Linux" ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  is_wsl=true
fi

platform_name="$os_type"
if [[ "$os_type" == "Darwin" ]]; then
  platform_name="macOS"
elif [[ "$is_wsl" == "true" ]]; then
  platform_name="Linux (WSL)"
fi

selected_phases=()
from_phase=""
resume=false
dry_run=false
check_only=false
non_interactive=false
no_color=false
ask_become_pass=true

red=""
blue=""
green=""
yellow=""
purple=""
reset=""

completed_phases=()
skipped_phases=()
current_phase=""

usage() {
  cat <<'EOF'
Usage:
  bash ~/.dotfiles/setup.sh [options]

Options:
  --check                    Run preflight checks only.
  --dry-run                  Print commands without executing them.
  --non-interactive          Avoid interactive prompts where possible.
  --no-ask-become-pass       Run ansible without --ask-become-pass.
  --phase <name>             Run only one phase (repeatable).
  --from-phase <name>        Run all phases starting at a phase.
  --resume                   Resume after last successful phase from checkpoint.
  --no-color                 Disable color output.
  --help                     Show this help.

Phases:
  bootstrap, packages, toolchains, dotfiles, config-management
EOF
}

log_info() {
  printf "%s[INFO]%s %s\n" "$blue" "$reset" "$1"
}

log_ok() {
  printf "%s[OK]%s %s\n" "$green" "$reset" "$1"
}

log_warn() {
  printf "%s[WARN]%s %s\n" "$yellow" "$reset" "$1"
}

log_error() {
  printf "%s[ERROR]%s %s\n" "$red" "$reset" "$1" >&2
}

run_cmd() {
  local cmd="$1"
  if [[ "$dry_run" == "true" ]]; then
    printf "%s[DRY-RUN]%s %s\n" "$purple" "$reset" "$cmd"
    return 0
  fi
  eval "$cmd"
}

phase_exists() {
  local target="$1"
  local phase
  for phase in "${PHASES[@]}"; do
    if [[ "$phase" == "$target" ]]; then
      return 0
    fi
  done
  return 1
}

phase_selected() {
  local phase="$1"
  local selected

  if [[ ${#selected_phases[@]} -gt 0 ]]; then
    for selected in "${selected_phases[@]}"; do
      if [[ "$selected" == "$phase" ]]; then
        return 0
      fi
    done
    return 1
  fi

  if [[ -n "$from_phase" ]]; then
    local seen=false
    for selected in "${PHASES[@]}"; do
      if [[ "$selected" == "$from_phase" ]]; then
        seen=true
      fi
      if [[ "$seen" == "true" && "$selected" == "$phase" ]]; then
        return 0
      fi
    done
    return 1
  fi

  return 0
}

initialize_colors() {
  if [[ "$no_color" == "true" ]]; then
    return
  fi
  if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    red="$(tput setaf 1 || true)"
    blue="$(tput setaf 4 || true)"
    green="$(tput setaf 2 || true)"
    yellow="$(tput setaf 3 || true)"
    purple="$(tput setaf 5 || true)"
    reset="$(tput sgr0 || true)"
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --check)
        check_only=true
        shift
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      --non-interactive)
        non_interactive=true
        shift
        ;;
      --no-ask-become-pass)
        ask_become_pass=false
        shift
        ;;
      --phase)
        shift
        if [[ $# -eq 0 ]]; then
          log_error "--phase requires a value."
          exit 1
        fi
        if ! phase_exists "$1"; then
          log_error "Unknown phase: $1"
          exit 1
        fi
        selected_phases+=("$1")
        shift
        ;;
      --from-phase)
        shift
        if [[ $# -eq 0 ]]; then
          log_error "--from-phase requires a value."
          exit 1
        fi
        if ! phase_exists "$1"; then
          log_error "Unknown phase: $1"
          exit 1
        fi
        from_phase="$1"
        shift
        ;;
      --resume)
        resume=true
        shift
        ;;
      --no-color)
        no_color=true
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done

  if [[ "$resume" == "true" && ${#selected_phases[@]} -gt 0 ]]; then
    log_error "--resume cannot be combined with --phase."
    exit 1
  fi

  if [[ "$resume" == "true" && -n "$from_phase" ]]; then
    log_error "--resume cannot be combined with --from-phase."
    exit 1
  fi
}

write_checkpoint() {
  local phase="$1"
  if [[ "$dry_run" == "true" ]]; then
    return
  fi
  printf "last_successful_phase=%s\n" "$phase" > "$CHECKPOINT_FILE"
}

apply_resume() {
  if [[ "$resume" != "true" ]]; then
    return
  fi

  if [[ ! -f "$CHECKPOINT_FILE" ]]; then
    log_warn "No checkpoint file found. Starting from the beginning."
    return
  fi

  local last_phase
  last_phase="$(grep -E '^last_successful_phase=' "$CHECKPOINT_FILE" | cut -d'=' -f2- || true)"
  if [[ -z "$last_phase" ]]; then
    log_warn "Checkpoint file is empty. Starting from the beginning."
    return
  fi

  local phase
  local next_phase=""
  for phase in "${PHASES[@]}"; do
    if [[ "$phase" == "$last_phase" ]]; then
      next_phase="__found__"
      continue
    fi
    if [[ "$next_phase" == "__found__" ]]; then
      next_phase="$phase"
      break
    fi
  done

  if [[ "$next_phase" == "__found__" || -z "$next_phase" ]]; then
    log_ok "All phases already completed according to checkpoint."
    exit 0
  fi

  from_phase="$next_phase"
  log_info "Resuming from phase: $from_phase"
}

require_cmd() {
  local cmd="$1"
  local reason="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_error "$cmd is required: $reason"
    return 1
  fi
  return 0
}

source_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return 0
  fi

  local brew_candidates=()
  if [[ "$os_type" == "Darwin" ]]; then
    brew_candidates=(
      "/opt/homebrew/bin/brew"
      "/usr/local/bin/brew"
    )
  else
    brew_candidates=(
      "/home/linuxbrew/.linuxbrew/bin/brew"
      "$HOME/.linuxbrew/bin/brew"
    )
  fi

  local brew_bin
  for brew_bin in "${brew_candidates[@]}"; do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done

  return 1
}

preflight_checks() {
  log_info "Running preflight checks for $platform_name"

  if [[ "$os_type" != "Darwin" && "$os_type" != "Linux" ]]; then
    log_error "Unsupported operating system: $os_type"
    return 1
  fi

  if [[ ! -d "$DOTFILES_DIR" ]]; then
    log_error "Expected dotfiles repository at $DOTFILES_DIR"
    return 1
  fi

  if [[ ! -f "$BREW_FILE" ]]; then
    log_error "Missing Brewfile: $BREW_FILE"
    return 1
  fi

  if [[ ! -f "$PLAYBOOK_FILE" ]]; then
    log_error "Missing ansible playbook: $PLAYBOOK_FILE"
    return 1
  fi

  require_cmd git "bootstrap dependencies"
  require_cmd curl "bootstrap dependencies"

  if ! curl -fsSI https://github.com >/dev/null 2>&1; then
    log_warn "Network check to github.com failed. Setup may fail later."
  else
    log_ok "Network check passed."
  fi

  if phase_selected "config-management"; then
    require_cmd sudo "config-management phase requires privilege escalation"
  fi

  log_ok "Preflight checks completed."
}

phase_bootstrap() {
  log_info "Phase: bootstrap"
  source_homebrew || true

  require_cmd git "required before Homebrew and repository operations"
  require_cmd curl "required to install Homebrew"

  if ! command -v brew >/dev/null 2>&1; then
    log_info "Installing Homebrew"
    local installer_cmd='NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    run_cmd "$installer_cmd"
    source_homebrew || true
  fi

  require_cmd brew "required for package installation"
  log_ok "bootstrap completed."
}

phase_packages() {
  log_info "Phase: packages"
  source_homebrew
  require_cmd brew "required for package installation"

  run_cmd "brew install mise"
  run_cmd "brew bundle install --file=\"$BREW_FILE\""

  if command -v pipx >/dev/null 2>&1; then
    if [[ "$dry_run" == "true" ]]; then
      printf "%s[DRY-RUN]%s pipx install argcomplete || pipx upgrade argcomplete\n" "$purple" "$reset"
    else
      pipx install argcomplete || pipx upgrade argcomplete
    fi
  fi

  log_ok "packages completed."
}

phase_toolchains() {
  log_info "Phase: toolchains"
  require_cmd mise "required for runtime/toolchain management"

  run_cmd "mise trust \"$DOTFILES_DIR/mise.toml\""
  run_cmd "mise install"
  log_ok "toolchains completed."
}

phase_dotfiles() {
  log_info "Phase: dotfiles"
  require_cmd mise "required for dotfiles application"
  run_cmd "mise dotfiles apply --yes"
  log_ok "dotfiles completed."
}

phase_config_management() {
  log_info "Phase: config-management"
  require_cmd ansible-galaxy "required for ansible role management"
  require_cmd ansible-playbook "required to apply setup.yaml"

  if [[ ! -d "$ANSIBLE_LOCAL_ROLES" ]]; then
    run_cmd "mkdir -p \"$ANSIBLE_LOCAL_ROLES\""
    if [[ "$dry_run" != "true" ]]; then
      pushd "$ANSIBLE_LOCAL_ROLES" >/dev/null
      if [[ ! -d "$ANSIBLE_LOCAL_ROLES/local_config" ]]; then
        ansible-galaxy role init local_config
      fi
      popd >/dev/null
    fi
  fi

  if [[ "$dry_run" != "true" ]]; then
    ansible-galaxy install -r "$REQUIREMENTS_FILE" -f
  else
    printf "%s[DRY-RUN]%s ansible-galaxy install -r \"%s\" -f\n" "$purple" "$reset" "$REQUIREMENTS_FILE"
  fi

  run_cmd "mkdir -p \"$ANSIBLE_LOCAL_PLUGINS\""
  if [[ "$dry_run" != "true" ]]; then
    cp "$ANSIBLE_LOCAL_ROLES/ansible-output-prettify/files/prettify.py" "$ANSIBLE_LOCAL_PLUGINS"
  else
    printf "%s[DRY-RUN]%s cp \"%s\" \"%s\"\n" "$purple" "$reset" "$ANSIBLE_LOCAL_ROLES/ansible-output-prettify/files/prettify.py" "$ANSIBLE_LOCAL_PLUGINS"
  fi

  run_cmd "mkdir -p \"$INVENTORY_DIR\""
  if [[ "$dry_run" != "true" ]]; then
    printf "[servers]\nlocalhost ansible_connection=local\n" > "$INVENTORY_FILE"
  else
    printf "%s[DRY-RUN]%s write inventory file to %s\n" "$purple" "$reset" "$INVENTORY_FILE"
  fi

  local ansible_cmd="ansible-playbook \"$PLAYBOOK_FILE\" -i \"$INVENTORY_FILE\""
  if [[ "$ask_become_pass" == "true" && "$non_interactive" != "true" ]]; then
    ansible_cmd="$ansible_cmd --ask-become-pass"
  else
    ansible_cmd="$ansible_cmd --become"
  fi

  run_cmd "$ansible_cmd"
  log_ok "config-management completed."
}

on_error() {
  local line="$1"
  log_error "Setup failed in phase '${current_phase:-unknown}' at line $line."
  if [[ "$dry_run" != "true" ]]; then
    log_info "Fix the issue and run again with --resume to continue from the next phase."
  fi
  exit 1
}

run_phase() {
  local phase="$1"
  current_phase="$phase"
  printf "\n%s==>%s Running phase: %s\n" "$purple" "$reset" "$phase"

  case "$phase" in
    bootstrap) phase_bootstrap ;;
    packages) phase_packages ;;
    toolchains) phase_toolchains ;;
    dotfiles) phase_dotfiles ;;
    config-management) phase_config_management ;;
    *)
      log_error "Unknown phase at execution time: $phase"
      exit 1
      ;;
  esac

  completed_phases+=("$phase")
  write_checkpoint "$phase"
  current_phase=""
}

main() {
  parse_args "$@"
  initialize_colors
  trap 'on_error $LINENO' ERR

  if [[ "$non_interactive" == "true" ]]; then
    ask_become_pass=false
  fi

  if ! cd "$DOTFILES_DIR"; then
    log_error "Unable to enter $DOTFILES_DIR"
    exit 1
  fi

  apply_resume
  preflight_checks

  if [[ "$check_only" == "true" ]]; then
    log_ok "Preflight checks passed."
    exit 0
  fi

  log_info "Setting up $platform_name"
  source_homebrew || true

  if [[ -x "$HOME/.zplug/repos/chriskempson/base16-shell/colortest" && "$dry_run" != "true" ]]; then
    "$HOME/.zplug/repos/chriskempson/base16-shell/colortest"
  fi

  local phase
  for phase in "${PHASES[@]}"; do
    if phase_selected "$phase"; then
      run_phase "$phase"
    else
      skipped_phases+=("$phase")
    fi
  done

  printf "\n%s==> Summary%s\n" "$purple" "$reset"
  printf "  Completed: %s\n" "${#completed_phases[@]}"
  if [[ ${#completed_phases[@]} -gt 0 ]]; then
    printf "    %s\n" "${completed_phases[*]}"
  fi
  printf "  Skipped:   %s\n" "${#skipped_phases[@]}"
  if [[ ${#skipped_phases[@]} -gt 0 ]]; then
    printf "    %s\n" "${skipped_phases[*]}"
  fi
  log_ok "Setup finished."
}

main "$@"
