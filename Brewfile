# vim: set ft=ruby: #
$PERSONAL_MACHINE = `hostname`.include?('sowderca')

$GO_DEV_TOOLS     = true
$RUST_DEV_TOOLS   = false
$JAVA_DEV_TOOLS   = true
$AZURE_DEV_TOOLS  = true
$DOTNET_DEV_TOOLS = true

# If there is a built-in API to do this via Homebrew that'd be great...
def missing?(cmd)
  return `which #{cmd} 2>/dev/null`.empty?
end

def installed?(app)
  if not missing?('flatpak')
    return `command -v #{app} 2>/dev/null`.empty?
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

tap 'isen-ng/dotnet-sdk-versions' if OS.mac? and $DOTNET_DEV_TOOLS

# Absolute garbage that we use at work.
tap "checkmarx/ast-cli"

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
brew 'helm'
brew 'rbenv'
brew 'rbenv'
brew 'trash', link: true if OS.mac?
brew 'neovim'
brew 'hubble'
brew 'ansible'
brew 'sslscan'
brew 'git-lfs'
brew 'watchman'
brew 'dos2unix'
brew 'container' if OS.mac?
brew 'protolint'
brew 'cilium-cli'
brew 'circumflex' # Hackernews TUI
brew 'ipinfo-cli'
brew 'kubernetes-cli'
brew 'reattach-to-user-namespace' if OS.mac?

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

brew 'teamookla/speedtest/speedtest'

# Trash work tooling
brew "checkmarx/ast-cli/ast-cli"

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
krew 'aks'
krew 'krew'

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

  go "github.com/google/gops"
  go "github.com/google/wire/cmd/wire"

  go "github.com/go-delve/delve/cmd/dlv"

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
  flatpak "org.gnome.seahorse.Application" unless installed? "org.gnome.seahorse.Application"


  flatpak "com.slack.Slack"
  flatpak 'app.devsuite.Schemes'
  flatpak "com.github.hugolabe.Wike" # Wikipedia
  flatpak "com.mattjakeman.ExtensionManager"

  # <3 Morrowind & Path Of Exile.
  if $PERSONAL_MACHINE
    flatpak 'org.openmw.OpenMW'
    flatpak 'tv.plex.PlexDesktop'
    flatpak 'com.discordapp.Discord'
    flatpak 'org.prismlauncher.PrismLauncher'
    flatpak 'community.pathofbuilding.PathOfBuilding'

    # This is in beta-ish...only used for work destiny.
    unless installed? 'com.nvidia.geforcenow'
      flatpak 'com.nvidia.geforcenow', remote: GForceNow, url: 'https://international.download.nvidia.com/GFNLinux/flat' 
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

    cask "microsoft-azure-storage-explorer"
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
  mas "Xcode", id: 497799835
  mas "Slack", id: 803453959
  mas "Sketch", id: 1667260533
  mas "Keyshape", id: 1223341056
  mas "Developer", id: 640199958
  mas "TestFlight", id: 899247664
  mas "OmniGraffle", id: 1142578753
  mas "Windows App", id: 1295203466
  mas "Microsoft Excel", id: 462058435
  mas "Affinity Photo 2", id: 1616822987
  mas "Affinity Designer 2", id: 1616831348
  mas "Affinity Publisher 2", id: 1606941598

  # Usually to the other linux machine on the home local network.
  if $PERSONAL_MACHINE
    mas "Steam Link", id: 1246969117
  end

end

if OS.wsl?

  # This is still in TODO status...
  # Need to automate a bunch of OS stuff in pwsh or ansible... Will only test in winboat / parallels since I no longer have a windows machine.

  # Basics
  winget "Edit", id: "Microsoft.Edit", source: "winget"
  winget "WinDbg", id: "9PGJGD53TN86", source: "msstore"
  winget "PowerShell", id: "9MZ1SNWT0N5D", source: "msstore"
  winget "Windows Performance Analyzer", id: "9N0W1B2BXGNZ", source: "msstore"
  winget "Microsoft Visual Studio Code", id: "Microsoft.VisualStudioCode", source: "winget"

  # DevOps tooling
  winget "Helm", id: "Helm.Helm", source: "winget"
  winget "Hubble", id: "Cilium.Hubble", source: "winget"
  winget "Cilium CLI", id: "Cilium.CLI", source: "winget"
  winget "Kubernetes CLI", id: "Kubernetes.kubectl", source: "winget"
  winget "Docker Desktop", id: "Docker.DockerDesktop", source: "winget"

  # Hashicorp tooling
  winget "Vagrant", id: "Hashicorp.Vagrant", source: "winget"
  winget "Hashicorp Vault", id: "Hashicorp.Vault", source: "winget"
  winget "Hashicorp Nomad", id: "Hashicorp.Nomad", source: "winget"
  winget "Hashicorp Packer", id: "Hashicorp.Packer", source: "winget"
  winget "Hashicorp Consul", id: "Hashicorp.Consul", source: "winget"
  winget "Hashicorp Terraform", id: "Hashicorp.Terraform", source: "winget"

  if $DOTNET_DEV_TOOLS
    # Install features manually for now... :(
    winget "Visual Studio Enterprise 2026", id: "Microsoft.VisualStudio.Enterprise", source: "winget"
    winget "Microsoft SQL Server Management Studio 22", id: "Microsoft.SQLServerManagementStudio.22", sourec: "winget"
  end

  if $AZURE_DEV_TOOLS
    winget "Bicep CLI", id: "Microsoft.Bicep", source: "winget"
    winget "Microsoft Azure CLI", id: "Microsoft.AzureCLI", source: "winget"
    winget "Azure Cosmos DB Emulator", id: "Microsoft.Azure.CosmosEmulator", source: "winget"
    winget "Azure Function Core Tools", id: "Microsoft.Azure.FunctionsCoreTools", source: "winget"
    winget "Microsoft Azure Storage Explorer",  id: "Microsoft.Azure.StorageExplorer", source: "winget"
    winget "Microsoft Azure Storage Emulator",  id: "Microsoft.Azure.StorageEmulator", source: "winget"
  end

  if $PERSONAL_MACHINE
    winget "Steam", id: "Valve.Steam", source: "winget"
    winget "Discord", id: "Discord.Discord", source: "winget"
    winget "PowerToys", id: "XP89DCGQ3K6VLD", source: "msstore"
  end

end

# Minimum VSCode extensions.
vscode 'vscodevim.vim'
vscode 'jdinhlife.gruvbox'
vscode 'vscode-icons-team.vscode-icons'

# These have gotten out of hand.... I can clean up from my mac.
vscode "13xforever.language-x86-64-assembly"
vscode "alefragnani.project-manager"
vscode "angular.ng-template"
vscode "anweber.httpbook"
vscode "anweber.vscode-httpyac"
vscode "arcsector.vscode-splunk-search-syntax"
vscode "argutec.argutec-azure-repos"
vscode "azat-io.vscode-gruvbox-icon-theme"
vscode "bdavs.expect"
vscode "be5invis.toml"
vscode "coderabbit.coderabbit-vscode"
vscode "dan-c-underwood.arm"
vscode "darian-benam.vscode-robots-dot-txt-support"
vscode "davidanson.vscode-markdownlint"
vscode "dbaeumer.vscode-eslint"
vscode "docker.docker"
vscode "dotjoshjohnson.xml"
vscode "drblury.protobuf-vsc"
vscode "drcika.apc-extension"
vscode "editorconfig.editorconfig"
vscode "erlang-ls.erlang-ls"
vscode "estivo.csv-editor"
vscode "fabiospampinato.vscode-todo-plus"
vscode "github.copilot-chat"
vscode "github.vscode-pull-request-github"
vscode "gleam.gleam"
vscode "golang.go"
vscode "graphql.vscode-graphql-syntax"
vscode "hashicorp.terraform"
vscode "hbenl.vscode-test-explorer"
vscode "humao.rest-client"
vscode "ide-innovation-lab.cangjie"
vscode "ionide.ionide-fsharp"
vscode "ionutvmi.reg"
vscode "jdinhlife.gruvbox"
vscode "jtavin.ldif"
vscode "kcl.kcl-vscode-extension"
vscode "llvm-vs-code-extensions.lldb-dap"
vscode "lucono.karma-test-explorer"
vscode "mike-lischke.vscode-antlr4"
vscode "mindaro-dev.file-downloader"
vscode "mint-lang.mint"
vscode "ms-azure-devops.azure-pipelines"
vscode "ms-azure-load-testing.microsoft-testing"
vscode "ms-azuretools.azure-dev"
vscode "ms-azuretools.vscode-azure-github-copilot"
vscode "ms-azuretools.vscode-azure-mcp-server"
vscode "ms-azuretools.vscode-azureappservice"
vscode "ms-azuretools.vscode-azurecontainerapps"
vscode "ms-azuretools.vscode-azurefunctions"
vscode "ms-azuretools.vscode-azureresourcegroups"
vscode "ms-azuretools.vscode-azurestaticwebapps"
vscode "ms-azuretools.vscode-azurestorage"
vscode "ms-azuretools.vscode-azurevirtualmachines"
vscode "ms-azuretools.vscode-bicep"
vscode "ms-azuretools.vscode-containers"
vscode "ms-azuretools.vscode-cosmosdb"
vscode "ms-azuretools.vscode-docker"
vscode "ms-azuretools.vscode-documentdb"
vscode "ms-dotnettools.csdevkit"
vscode "ms-dotnettools.csharp"
vscode "ms-dotnettools.vscode-dotnet-modernize"
vscode "ms-dotnettools.vscode-dotnet-runtime"
vscode "ms-edgedevtools.vscode-edge-devtools"
vscode "ms-kubernetes-tools.kind-vscode"
vscode "ms-kubernetes-tools.vscode-aks-tools"
vscode "ms-kubernetes-tools.vscode-kubernetes-tools"
vscode "ms-mssql.data-workspace-vscode"
vscode "ms-mssql.mssql"
vscode "ms-mssql.sql-bindings-vscode"
vscode "ms-mssql.sql-database-projects-vscode"
vscode "ms-ossdata.vscode-pgsql"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-sarifvscode.sarif-viewer"
vscode "ms-toolsai.datawrangler"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-vscode-remote.remote-ssh"
vscode "ms-vscode-remote.remote-ssh-edit"
vscode "ms-vscode-remote.remote-wsl"
vscode "ms-vscode-remote.vscode-remote-extensionpack"
vscode "ms-vscode.cpptools"
vscode "ms-vscode.makefile-tools"
vscode "ms-vscode.powershell"
vscode "ms-vscode.remote-explorer"
vscode "ms-vscode.remote-server"
vscode "ms-vscode.test-adapter-converter"
vscode "ms-vscode.vscode-node-azure-pack"
vscode "ms-vsliveshare.vsliveshare"
vscode "ms-windows-ai-studio.windows-ai-studio"
vscode "msjsdiag.vscode-react-native"
vscode "mtxr.sqltools"
vscode "mtxr.sqltools-driver-mysql"
vscode "peerstudios.buck2-lsp-adapter"
vscode "poml-team.poml"
vscode "redhat.fabric8-analytics"
vscode "redhat.java"
vscode "redhat.vscode-xml"
vscode "redhat.vscode-yaml"
vscode "rosshamish.kuskus-kusto-syntax-highlighting"
vscode "rust-lang.rust-analyzer"
vscode "serpen.vbsvscode"
vscode "shopify.ruby-lsp"
vscode "streetsidesoftware.code-spell-checker"
vscode "stylelint.vscode-stylelint"
vscode "sumneko.lua"
vscode "swiftlang.swift-vscode"
vscode "syler.sass-indented"
vscode "teamsdevapp.vscode-ai-foundry"
vscode "tintoy.msbuild-project-tools"
vscode "typespec.typespec-vscode"
vscode "vadimcn.vscode-lldb"
vscode "vosca.vscode-v-analyzer"
vscode "vscjava.vscode-gradle"
vscode "vscjava.vscode-java-debug"
vscode "vscjava.vscode-java-dependency"
vscode "vscjava.vscode-java-pack"
vscode "vscjava.vscode-java-test"
vscode "vscjava.vscode-java-upgrade"
vscode "vscjava.vscode-maven"
vscode "vscode-icons-team.vscode-icons"
vscode "vscodevim.vim"
vscode "wayou.vscode-todo-highlight"
vscode "webben.browserslist"
vscode "wso2.ballerina"
vscode "wso2.wso2-platform"
