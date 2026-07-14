#!/usr/bin/env zsh

# Basic variables.
os_type="$(builtin command uname)"
brew_file=~/.dotfiles/Brewfile
ansible_local_roles=~/.ansible/roles
ansible_local_plugins=~/.ansible/plugins/callback

# Color output.
red=$(tput setaf 1)
blue=$(tput setaf 4)
reset=$(tput sgr0)
green=$(tput setaf 2)
purple=$(tput setaf 5)


function source_homebrew() {
  if [[ $os_type = *"Darwin"* ]]; then
    test -d /opt/homebrew/ && eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

source_homebrew

for tool in git curl brew; do
  if builtin command -v $tool >/dev/null 2>&1; then
    echo "✅ ${green}$tool is installed...${reset}"
    continue
  fi

  if [ "$tool" = "brew" ]; then
    echo -e "${blue}==> Installing homebrew...${reset}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! builtin command -v $tool >/dev/null 2>&1; then
    echo "❌ ${red}$tool is missing... it's required to setup and configure the machine.${reset}"
    exit 1
  fi
done

if ! cd ~/.dotfiles; then
  echo "Failed to change directory to ~/.dotfiles. Please check if the directory exists and try again."
  exit 1
fi

echo -e "\n${purple}==> Setting up $os_type...${reset}\n"

source_homebrew

echo -e "\n${purple}==> Sourcing zsh configuration...${reset}\n"

if [[ -f ~/.zplug/repos/chriskempson/base16-shell/colortest ]]; then
  ~/.zplug/repos/chriskempson/base16-shell/colortest
fi

echo -e "\n${purple}==> Installing mise...${reset}\n"
brew install mise
echo -e "\n"

pipx install argcomplete

if builtin command -v mise >/dev/null 2>&1; then
  mise trust ~/.dotfiles/mise.toml
  mise install
  mise dotfiles apply --yes
else
  echo "❌ ${red}mise is missing after brew bundle install.${reset}"
  exit 1
fi

brew bundle install --file=$brew_file

if ! [[ -d $ansible_local_roles ]]; then
  mkdir -p $ansible_local_roles
  pushd -q $ansible_local_roles || echo "❌ ${red}unable to change directory to ${ansible_local_roles}.${reset}" && exit 1
  ansible-galaxy role init local_config
  popd -q || echo "❌ ${red}unable to return to previous directory.${reset}" && exit 1
fi

if ! [[ -f /etc/ansible/hosts ]]; then
  sudo mkdir -p /etc/ansible
  sudo touch /etc/ansible/hosts
fi

# Default ansible output is so ugly.
if ! [[ -f ~/.ansible/plugins/callback/prettify.py ]]; then
  ansible-galaxy install -r ~/.dotfiles/requirements.yml -f
  mkdir -p $ansible_local_plugins
  cp ~/.ansible/roles/ansible-output-prettify/files/prettify.py $ansible_local_plugins
fi

sudo printf "[servers]\nlocalhost ansible_connection=local\n" | sudo tee /etc/ansible/hosts > /dev/null

ansible-playbook ~/.dotfiles/setup.yaml --ask-become-pass
