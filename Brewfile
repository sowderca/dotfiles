# vim: set ft=ruby: #

$PERSONAL_MACHINE = `hostname`.include?('sowderca')

$GO_DEV_TOOLS     = true
$NODE_DEV_TOOLS   = true
$RUST_DEV_TOOLS   = false
$JAVA_DEV_TOOLS   = true
$AZURE_DEV_TOOLS  = true
$DOTNET_DEV_TOOLS = true


# If there is a built-in API to do this via Homebrew that'd be great...
def missing?(cmd) = `which #{cmd} 2>/dev/null`.empty?

def installed?(app)
  if not missing?('flatpak')
    return `command -v #{app} 2>/dev/null`.empty?
  else
    return false
  end
end

# MS cloud tooling.
tap 'dapr/tap', trusted: true

tap 'azure/azd', trusted: true
tap 'azure/bicep', trusted: true
tap 'azure/functions', trusted: true

# More corpo tooling.
tap 'facebook/fb', trusted: true
tap 'hashicorp/tap', trusted: true

# Useful things.
tap 'teamookla/speedtest', trusted: true
tap 'thoughtbot/formulae', trusted: true

# Used alot for local prototyping.
tap 'nats-io/nats-tools',  trusted: true

tap 'isen-ng/dotnet-sdk-versions', trusted: true if OS.mac? and $DOTNET_DEV_TOOLS

# Absolute garbage that we use at work.
tap 'checkmarx/ast-cli', trusted: true

brew 'go'
brew 'mas' if OS.mac?
brew 'krew'
brew 'rust'

brew 'gh'
brew 'bat'
brew 'hub'
brew 'opa'
brew 'rcm'
brew 'fpp'
brew 'pipx' if OS.mac?
brew 'nmap'
brew 'kind'
brew 'tree'
brew 'grpc'
brew 'serf'
brew 'helm' if not OS.wsl?
brew 'rbenv'
brew 'rbenv'
brew 'trash', link: true if OS.mac?
brew 'neovim'
brew 'hubble' if not OS.wsl?
brew 'ansible'
brew 'sslscan'
brew 'git-lfs' if not OS.wsl?
brew 'watchman'
brew 'dos2unix'
brew 'container' if OS.mac?
brew 'protolint'
brew 'cilium-cli' if not OS.wsl?
brew 'circumflex' # Hackernews TUI
brew 'ipinfo-cli'
brew 'kubernetes-cli' if not OS.wsl?
brew 'reattach-to-user-namespace' if OS.mac?

# Hashicorp tooling.
if not OS.wsl?
  brew 'hashicorp/tap/nomad'
  brew 'hashicorp/tap/vault'
  brew 'hashicorp/tap/consul'
  brew 'hashicorp/tap/packer'
  brew 'hashicorp/tap/sentinel'
  brew 'hashicorp/tap/terraform'
end

# NATS tooling.
brew 'nats-io/nats-tools/nsc'
brew 'nats-io/nats-tools/nats'

brew 'teamookla/speedtest/speedtest'

# Trash work tooling
brew 'checkmarx/ast-cli/ast-cli'

# Some of these tools come bundled with Linux but are usually missing on macOS.
brew 'jq'        if missing? 'jq'
brew 'fzf'       if missing? 'fzf'
brew 'tmux'      if missing? 'tmux'
brew 'curl'      if missing? 'curl'
brew 'wget'      if missing? 'wget'
brew 'telnet'    if missing? 'telnet'
brew 'ffmpeg'    if missing? 'ffmpeg'
brew 'git-lfs'   if missing? 'git-lfs'
brew 'fastfetch' if missing? 'fastfetch'

# Java stuff.
brew 'maven'     if $JAVA_DEV_TOOLS
brew 'gradle'    if $JAVA_DEV_TOOLS
brew 'ballerina' if $JAVA_DEV_TOOLS

# .NET stuff.
brew 'nuget' if $DOTNET_DEV_TOOLS

# k8s cli plugins
if not OS.wsl?
  krew 'aks'
  krew 'krew'
end

if $NODE_DEV_TOOLS and installed? 'nvm'
  npm 'neovim'
  npm 'firebase-tools'
  # Work still uses global tooling in some automation...
  npm '@angular/cli'
  npm '@blackbaud-internal/sky-cli'
  npm '@blackbaud-internal/skyux-cli'
end

# Go and go global binaries.
go 'sigs.k8s.io/bom/cmd/bom'
go 'github.com/posener/complete/gocomplete'

if $GO_DEV_TOOLS

  go 'golang.org/x/tools/gopls'
  go 'golang.org/x/tools/cmd/digraph'
  go 'golang.org/x/tools/cmd/deadcode'
  go 'golang.org/x/tools/cmd/stringer'
  go 'golang.org/x/tools/cmd/goimports'
  go 'golang.org/x/tools/cmd/callgraph'
  go 'golang.org/x/tools/cmd/toolstash'

  go 'google.golang.org/protobuf/cmd/protoc-gen-go'
  go 'google.golang.org/grpc/cmd/protoc-gen-go-grpc'

  go 'github.com/google/gops'
  go 'github.com/google/wire/cmd/wire'

  go 'github.com/go-delve/delve/cmd/dlv'

end

cargo 'tealdeer' # This is newer version of tldr.

# Rust and rust global binaries.
if $RUST_DEV_TOOLS
  brew 'rustup'
end

if OS.linux?

  # Gnome applications that can function normally in a sandbox.
  flatpak 'org.gnome.dspy'                 unless installed? 'org.gnome.dspy'
  flatpak 'org.gnome.Logs'                 unless installed? 'org.gnome.Logs'
  flatpak 'org.gnome.meld'                 unless installed? 'org.gnome.meld'
  flatpak 'org.gnome.Boxes'                unless installed? 'org.gnome.Boxes'
  flatpak 'org.gnome.Geary'                unless installed? 'org.gnome.Geary'
  flatpak 'org.gnome.Manuals'              unless installed? 'org.gnome.Manuals'
  flatpak 'org.gnome.Weather'              unless installed? 'org.gnome.Weather'
  flatpak 'org.gnome.Podcasts'             unless installed? 'org.gnome.Podcasts'
  flatpak 'org.gnome.Contacts'             unless installed? 'org.gnome.Contacts'
  flatpak 'org.gnome.Calendar'             unless installed? 'org.gnome.Calendar'
  flatpak 'org.gnome.TextEditor'           unless installed? 'org.gnome.TextEditor'
  flatpak 'org.gnome.Connections'          unless installed? 'org.gnome.Connections'
  flatpak 'org.gnome.font-viewer'          unless installed? 'org.gnome.font-viewer'
  flatpak 'org.gnome.seahorse.Application' unless installed? 'org.gnome.seahorse.Application'


  flatpak 'com.slack.Slack'
  flatpak 'app.devsuite.Schemes'
  flatpak 'com.github.hugolabe.Wike' # Wikipedia
  flatpak 'com.mattjakeman.ExtensionManager'

  # <3 Morrowind & Path Of Exile.
  if $PERSONAL_MACHINE
    flatpak 'org.openmw.OpenMW'
    flatpak 'tv.plex.PlexDesktop'
    flatpak 'com.discordapp.Discord'
    flatpak 'org.prismlauncher.PrismLauncher'
    flatpak 'community.pathofbuilding.PathOfBuilding'

    # This is in beta-ish...only used for work destiny.
    unless installed? 'com.nvidia.geforcenow'
      flatpak 'com.nvidia.geforcenow', remote: 'GForceNow', url: 'https://international.download.nvidia.com/GFNLinux/flat' 
    end

  end
end

# MacOS standard apps.
if OS.mac?

  cask 'iterm2'
  cask 'dbngin'
  cask 'vagrant'
  cask 'rapidapi'
  cask 'steamcmd'
  cask 'parallels'
  cask 'tableplus'
  cask 'gpg-suite'
  cask 'expo-orbit'
  cask 'docker-desktop'
  cask 'origami-studio'
  cask 'microsoft-edge'
  cask 'microsoft-teams'
  cask 'citrix-workspace' # Hopefully one day this can be removed...
  cask 'visual-studio-code'

  # AI PR 'helper'
  cask 'coderabbit'

  if $DOTNET_DEV_TOOLS
    cask 'dotnet-sdk'
  end

  if $JAVA_DEV_TOOLS
    cask 'visualvm'
    cask 'graalvm-jdk'
    cask 'android-studio'
    cask 'microsoft-openjdk'
    cask 'jdk-mission-control'
  end

  # Azure stuff.
  if $AZURE_DEV_TOOLS
    brew 'powershell'
    brew 'azure/azd/azd'
    brew 'azure/bicep/bicep'
    brew 'azure/functions/azure-functions-core-tools'

    cask 'microsoft-azure-storage-explorer'
  end

  # Gaming things.
  if $PERSONAL_MACHINE
    cask 'plex'
    cask 'steam'
    cask 'discord'
    cask 'qmk-toolbox'
    cask 'dungeon-crawl-stone-soup-console' # No TUI only version for macOS that works well.
  end

  if !Hardware::CPU.arm?
    brew 'xhyve' # Hacky BSD emulator for CNS.
  end

  # I use more but need to slim down whats required.
  mas 'Xcode', id: 497799835
  mas 'Slack', id: 803453959
  mas 'Sketch', id: 1667260533
  mas 'Keyshape', id: 1223341056
  mas 'Developer', id: 640199958
  mas 'TestFlight', id: 899247664
  mas 'OmniGraffle', id: 1142578753
  mas 'Windows App', id: 1295203466
  mas 'Microsoft Excel', id: 462058435
  mas 'Affinity Photo 2', id: 1616822987
  mas 'Affinity Designer 2', id: 1616831348
  mas 'Affinity Publisher 2', id: 1606941598

  # Usually to the other linux machine on the home local network.
  if $PERSONAL_MACHINE
    mas 'Steam Link', id: 1246969117
  end

end

if OS.wsl?

  # Basics
  winget 'Edit', id: 'Microsoft.Edit', source: 'winget'
  winget 'WinDbg', id: '9PGJGD53TN86', source: 'msstore'
  winget 'PowerToys', id: 'XP89DCGQ3K6VLD', source: 'msstore'
  winget 'TablePlus', id: 'TablePlus.TablePlus', source: 'winget'
  winget 'PowerShell', id: '9MZ1SNWT0N5D', source: 'msstore'
  winget 'Sysinternals Suite', id: '9P7KNL5RWT25', source: 'msstore'
  winget 'Windows Performance Analyzer', id: '9N0W1B2BXGNZ', source: 'msstore'
  winget 'Microsoft Visual Studio Code', id: 'Microsoft.VisualStudioCode', source: 'winget'

  # DevOps tooling
  winget 'Helm', id: 'Helm.Helm', source: 'winget'
  winget 'Hubble', id: 'Cilium.Hubble', source: 'winget'
  winget 'Cilium CLI', id: 'Cilium.CLI', source: 'winget'
  winget 'Kubernetes CLI', id: 'Kubernetes.kubectl', source: 'winget'
  winget 'Docker Desktop', id: 'Docker.DockerDesktop', source: 'winget'

  # Hashicorp tooling
  winget 'Vagrant', id: 'Hashicorp.Vagrant', source: 'winget'
  winget 'Hashicorp Vault', id: 'Hashicorp.Vault', source: 'winget'
  winget 'Hashicorp Nomad', id: 'Hashicorp.Nomad', source: 'winget'
  winget 'Hashicorp Packer', id: 'Hashicorp.Packer', source: 'winget'
  winget 'Hashicorp Consul', id: 'Hashicorp.Consul', source: 'winget'
  winget 'Hashicorp Terraform', id: 'Hashicorp.Terraform', source: 'winget'

  if $DOTNET_DEV_TOOLS
    # Install features manually for now... :(
    winget 'Visual Studio Enterprise 2026', id: 'Microsoft.VisualStudio.Enterprise', source: 'winget'
    winget 'Microsoft SQL Server Management Studio 22', id: 'Microsoft.SQLServerManagementStudio.22', sourec: 'winget'
  end

  if $AZURE_DEV_TOOLS
    winget 'Bicep CLI', id: 'Microsoft.Bicep', source: 'winget'
    winget 'Microsoft Azure CLI', id: 'Microsoft.AzureCLI', source: 'winget'
    winget 'Azure Cosmos DB Emulator', id: 'Microsoft.Azure.CosmosEmulator', source: 'winget'
    winget 'Azure Function Core Tools', id: 'Microsoft.Azure.FunctionsCoreTools', source: 'winget'
    winget 'Microsoft Azure Storage Explorer',  id: 'Microsoft.Azure.StorageExplorer', source: 'winget'
    winget 'Microsoft Azure Storage Emulator',  id: 'Microsoft.Azure.StorageEmulator', source: 'winget'
  end

  if $PERSONAL_MACHINE
    winget 'Steam', id: 'Valve.Steam', source: 'winget'
    winget 'Discord', id: 'Discord.Discord', source: 'winget'
    winget 'SteamCMD', id: 'Valve.SteamCMD', source: 'winget'
  end

end

# Minimum VSCode extensions.
vscode 'vscodevim.vim'
vscode 'jdinhlife.gruvbox'
vscode 'vscode-icons-team.vscode-icons'
