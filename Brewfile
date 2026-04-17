# vim: set ft=ruby: #

$PERSONAL_MACHINE = `hostname`.include?('sowderca')

$GO_DEV_TOOLS=true
$JAVA_DEV_TOOLS=true
$AZURE_DEV_TOOLS=true
$DOTNET_DEV_TOOLS=true

# If there is a built-in API to do this via Homebrew that'd be great...
def missing?(cmd)
  return `which #{cmd} 2>/dev/null`.empty?
end

def installed?(app)
  if not missing?('flatpak')
    return `flatpak list --columns=name | grep -i #{app}`.empty?
  else
    return false
  end
end

# MS cloud tooling.
tap 'dapr/tap'

tap 'azure/azd'
tap 'azure/bicep'
tap 'azure/functions'

# More corpo tooling.
tap 'facebook/fb'
tap 'hashicorp/tap'

# Useful things.
tap 'teamookla/speedtest'
tap 'thoughtbot/formulae'

# Used alot for local prototyping.
tap 'nats-io/nats-tools'

brew 'go'
brew 'mas' unless OS.linux?
brew 'krew'
brew 'rust'
brew 'rustup'

brew 'gh'
brew 'bat'
brew 'hub'
brew 'opa'
brew 'rcm'
brew 'fpp'
brew 'nmap'
brew 'kind'
brew 'tree'
brew 'grpc'
brew 'helm'
brew 'trash', link: true unless OS.linux?
brew 'neovim'
brew 'hubble'
brew 'sslscan'
brew 'watchman'
brew 'dos2unix'
brew 'protolint'
brew 'cilium-cli'
brew 'circumflex' # Hackernews TUI
brew 'ipinfo-cli'
brew 'kubernetes-cli'


# Hashicorp tooling.
brew 'hashicorp/tap/nomad'
brew 'hashicorp/tap/vault'
brew 'hashicorp/tap/consul'
brew 'hashicorp/tap/packer'
brew 'hashicorp/tap/sentinel'
brew 'hashicorp/tap/terraform'

# NATS tooling.
brew 'nats-io/nats-tools/nsc'
brew 'nats-io/nats-tools/nats'

# Some of these tools come bundled with Linux but are usually missing on macOS.
brew 'jq'      unless not missing? 'jq'
brew 'fzf'     unless not missing? 'fzf'
brew 'tmux'    unless not missing? 'tmux'
brew 'curl'    unless not missing? 'curl'
brew 'wget'    unless not missing? 'wget'
brew 'cmake'   unless not missing? 'cmake'
brew 'telnet'  unless not missing? 'telnet'
brew 'ffmpeg'  unless not missing? 'ffmpeg'
brew 'git-lfs' unless not missing? 'git-lfs'

# Java stuff.
brew 'maven'     unless not $JAVA_DEV_TOOLS
brew 'gradle'    unless not $JAVA_DEV_TOOLS
brew 'ballerina' unless not $JAVA_DEV_TOOLS

# .NET stuff.
brew 'nuget' unless not $DOTNET_DEV_TOOLS

# Go and go global binaries.
go 'sigs.k8s.io/bom/cmd/bom'

if $GO_DEV_TOOLS
  go 'golang.org/x/tools/gopls'
  # go 'golang.org/x/tools/cmd/diagraph'
  go 'golang.org/x/tools/cmd/deadcode'
  go 'golang.org/x/tools/cmd/goimports'
  go 'golang.org/x/tools/cmd/callgraph'

  go 'google.golang.org/protobuf/cmd/protoc-gen-go'
  go 'google.golang.org/grpc/cmd/protoc-gen-go-grpc'
end

# Gnome applications that can function normally in a sandbox.
flatpak 'org.gnome.Logs'        unless installed? 'org.gnome.Logs'
flatpak 'org.gnome.meld'        unless installed? 'org.gnome.meld'
flatpak 'org.gnome.Boxes'       unless installed? 'org.gnome.Boxes'
flatpak 'org.gnome.Geary'       unless installed? 'org.gnome.Geary'
flatpak 'org.gnome.Weather'     unless installed? 'org.gnome.Weather'
flatpak 'org.gnome.Podcasts'    unless installed? 'org.gnome.Podcasts'
flatpak 'org.gnome.Contacts'    unless installed? 'org.gnome.Contacts'
flatpak 'org.gnome.Calendar'    unless installed? 'org.gnome.Calendar'
flatpak 'org.gnome.TextEditor'  unless installed? 'org.gnome.TextEditor'
flatpak 'org.gnome.Connections' unless installed? 'org.gnome.Connections'
flatpak 'org.gnome.font-viewer' unless installed? 'org.gnome.font-viewer'

# <3 Morrowind & Path Of Exile.
if $PERSONAL_MACHINE
  flatpak 'org.openmw.OpenMW'
  flatpak 'com.discordapp.Discord'
  flatpak 'community.pathofbuilding.PathOfBuilding'
end

# MacOS standard apps.
if OS.mac?
  cask 'iterm2'
  cask 'dbngin'
  cask 'vagrant'
  cask 'debookee'
  cask 'rapidapi'
  cask 'parallels'
  cask 'tableplus'
  cask 'gpg-suite'
  cask 'expo-orbit'
  cask 'microsoft-edge'
  cask 'origami-studio'
  cask 'citrix-workspace' # Hopefully one day this can be removed...
  cask 'visual-studio-code'

  if $DOTNET_DEV_TOOLS
    cask 'dotnet-sdk'
    brew 'powershell'
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
    brew 'azure/azd/azd'
    brew 'azure/bicep/bicep'
    brew 'azure/functions/azure-functions-core-tools'
  end

  # Gaming things.
  if $PERSONAL_MACHINE
    cask 'discord'
    cask 'sideloadly'
    cask 'qmk-toolbox'
    cask 'dungeon-crawl-stone-soup-console' # No TUI only version for macOS that works well.
  end

  if !Hardware::CPU.arm?
    brew 'xhyve' # Hacky BSD emulator for CNS.
  end

end

# I use more but need to slim down whats required.
mas "Xcode", id: 497799835
mas "Sketch", id: 1667260533
mas "Keyshape", id: 1223341056
mas "Developer", id: 640199958
mas "TestFlight", id: 899247664
mas "OmniGraffle", id: 1142578753
mas "Windows App", id: 1295203466
mas "Microsoft Excel", id: 462058435

# Usually to the other linux machine on the home local network.
if $PERSONAL_MACHINE
  mas "Steam Link", id: 1246969117
end

puts "\e[0;35m Your prbly missing things double check the last update of this script on your backup images \e[0m\n"
