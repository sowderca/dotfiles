# frozen_string_literal: true

require "rbconfig"

host_os = RbConfig::CONFIG["host_os"]
host_is_macos = host_os.include?("darwin")
host_is_linux = host_os.include?("linux")

def default_macos_box
  return "cirruslabs/macos-tahoe-base" unless RbConfig::CONFIG["host_os"].include?("darwin")

  product_version = `sw_vers -productVersion 2>/dev/null`.strip
  major = product_version.split(".").first.to_i

  case major
    when 16
      "cirruslabs/macos-tahoe-base"
    when 15
      "cirruslabs/macos-sequoia-base"
    when 14
      "cirruslabs/macos-sonoma-base"
    when 13
      "cirruslabs/macos-ventura-base"
    when 12
      "cirruslabs/macos-monterey-base"
    else
      "cirruslabs/macos-tahoe-base"
  end
end

# Override these with environment variables as needed.
# CachyOS is rolling-release, so "latest" represents current.
cachyos_box = ENV.fetch("CACHYOS_BOX", "cachyos/cachyos")
cachyos_box_version = ENV.fetch("CACHYOS_BOX_VERSION", "latest")
macos_box = ENV.fetch("MACOS_BOX", default_macos_box)
enable_macos_on_linux = ENV.fetch("ENABLE_MACOS_VM_ON_LINUX", "0") == "1"

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  setup_preflight = <<~SHELL
    set -euo pipefail
    if [ -f /vagrant/setup.sh ]; then
      bash /vagrant/setup.sh --check --no-color
    fi
  SHELL

  config.vm.define "cachyos" do |cachyos|
    cachyos.vm.hostname = "dotfiles-cachyos"
    cachyos.vm.box = cachyos_box
    cachyos.vm.box_version = cachyos_box_version
    cachyos.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__auto: false

    if host_is_linux
      cachyos.vm.provider :libvirt do |lv|
        lv.cpus = ENV.fetch("CACHYOS_CPUS", "4").to_i
        lv.memory = ENV.fetch("CACHYOS_MEMORY", "8192").to_i
      end
    elsif host_is_macos
      cachyos.vm.provider :virtualbox do |vb|
        vb.cpus = ENV.fetch("CACHYOS_CPUS", "4").to_i
        vb.memory = ENV.fetch("CACHYOS_MEMORY", "8192").to_i
      end
    end

    cachyos.vm.provision "shell", name: "preflight-setup", privileged: false, inline: setup_preflight
  end

  config.vm.define "cachyos-docker" do |docker_target|
    docker_target.vm.provider :docker do |docker|
      docker.build_dir = "."
      docker.dockerfile = "Dockerfile.cachyos"
      docker.build_args = ["CACHYOS_IMAGE=#{ENV.fetch("CACHYOS_DOCKER_IMAGE", "ghcr.io/cachyos/cachyos:latest")}"]
      docker.name = "dotfiles-cachyos-test"
      docker.remains_running = false
      docker.has_ssh = false
    end
  end

  if host_is_macos || enable_macos_on_linux
    config.vm.define "macos" do |macos|
      macos.vm.hostname = "dotfiles-macos"
      macos.vm.box = macos_box
      macos.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__auto: false

      # Requires vagrant-tart plugin and Apple Virtualization.framework support.
      macos.vm.provider :tart do |t|
        t.cpus = ENV.fetch("MACOS_CPUS", "4").to_i
        t.memory = ENV.fetch("MACOS_MEMORY", "8192").to_i
      end

      macos.vm.provision "shell", name: "preflight-setup", privileged: false, inline: setup_preflight
    end
  else
    puts "[vagrant] Skipping macOS VM definition on non-macOS host. Set ENABLE_MACOS_VM_ON_LINUX=1 to force it."
  end
end
