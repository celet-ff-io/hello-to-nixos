# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
  # pkgs,
  ...
}:
let
  # Set it to where this repository you cloned is
  hello-to-nixos = "/path/to/hello-to-nixos";
in
{
  imports = [
    ./common.nix

    # Modules

    (import "${hello-to-nixos}/modules/devspec/commonhw.nix") # systemd boot
    (import "${hello-to-nixos}/modules/devspec/hw/wireless-adapter.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/thunderbolt.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/i2c.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/cpu/intel.nix") # Enable kvm-intel
    # (import "${hello-to-nixos}/modules/devspec/hw/cpu/amd.nix") # Enable kvm-amd
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/intel") # Enable i915
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/amd") # Enable amdgpu
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/nvidia/disable.nix") # Disable NVIDIA
    # (import "${hello-to-nixos}/modules/devspec/luks.nix" {
    #   deviceLuksProvides = "luksDevice0";
    #   deviceLuksOn = "/dev/disk/by-uuid/<uuid>";
    # })

    (import "${hello-to-nixos}/modules/common/os-builder.nix" "x86_64-linux") # Experimental features and mirrors
    (import "${hello-to-nixos}/modules/devspec/locale.nix") # Locale
    (import "${hello-to-nixos}/modules/devspec/watchdog.nix") # Watchdog
    (import "${hello-to-nixos}/modules/devspec/printer.nix")
    (import "${hello-to-nixos}/modules/devspec/sound.nix") # pipeware
    # (import "${hello-to-nixos}/modules/devspec/fprint.nix") # fprintd
    # (import "${hello-to-nixos}/modules/devspec/battery.nix") # power save

    (import "${hello-to-nixos}/modules/devspec/greet.nix") # greetd login
    (import "${hello-to-nixos}/modules/devspec/terminal.nix") # kmscon and more
    # (import "${hello-to-nixos}/modules/devspec/desk/common.nix") # Desktop common
    # (import "${hello-to-nixos}/modules/devspec/desk/hyprland.nix") # Hyprland
    # (import "${hello-to-nixos}/modules/devspec/virtualisation.nix") # Virtualisation (QEMU)

    # Enable only if you are using WSL
    # Please make sure your nixos-wsl in nix-channel is updated to lastest version
    # or wsl.ssh-agent.enable may not exist and cause error
    # <nixos-wsl/modules>
    # (import "${hello-to-nixos}/modules/devspec/wsl.nix" "nixos")

    (import "${hello-to-nixos}/modules/common/users.nix" "nixos")
    (import "${hello-to-nixos}/modules/common/basic-software.nix") # nvim, zsh, tmux, git and more
    (import "${hello-to-nixos}/modules/common/optional/ssh.nix")
    # (import "${hello-to-nixos}/modules/common/optional/developer.nix") # cargo and more
    # (import "${hello-to-nixos}/modules/common/optional/browsers.nix") # browser applications
    # (import "${hello-to-nixos}/modules/common/optional/documents.nix") # chafa and more
    # (import "${hello-to-nixos}/modules/common/optional/proxy.nix") # proxy applications
    # (import "${hello-to-nixos}/modules/common/optional/localsend.nix") # LocalSend
  ];
}
