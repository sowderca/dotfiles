#!/bin/bin/env zsh

function system-update() {

  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  local green=$(tput setaf 2)

  local help_flag
  local what_if_flag
  local "${os_type}"="$(builtin command uname)" || return 1

  local usage="
    system-update [--help]
    system-update [--what-if]
  "

  while [[ "$1" == -* ]]; do
    case "$1" in
      --help)
        help_flag=1
        shift
        ;;
      --what-if)
        what_if_flag=1
        shift
        ;;
      *)
        echo "${red}Unknown option: $1${reset}"
        echo "${red}$usage${reset}"
        return 1
        ;;
    esac
  done

  [[ -z "${help_flag}" ]] || { echo "${green}$usage${reset}" && return }

  if ! [[ -z $os_type ]]; then
    if [[ $os_type = *"Darwin"* ]]; then
      if (( $#what_if_flag )); then
        softwareupdate --list
      else
        softwareupdate --install --all
      fi
    else
      if (($+commands[cachy-update])); then
        if (( $#what_if_flag )); then
          checkupdates
        else
          cachy-update
        fi
      fi
    fi
  fi

  if (($+commands[brew])); then
    if (( $#what_if_flag )); then
      brew upgrade --dry-run
      brew upgrade --dry-run --cask
    else
      brew cleanup
      brew update
      brew upgrade
      brew upgrade --cask
    fi
  fi

}

