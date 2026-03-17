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
  hello-to-nixos = import /path/to/hello-to-nixos;
in
{
  imports = [
    ./common.nix
    # And more your own modules
  ]
  #
  # =============================
  # Required if you are using WSL
  # ++ [ <nixos-wsl/modules> ]
  # =============================
  #
  # Hello-to-NixOS Modules
  #
  # See `default.nix` at repository root
  # for detailed module definations
  ++ (with hello-to-nixos; [
    devspec.commonhw # systemd boot
    devspec.hw.wireless-adapter
    devspec.hw.thunderbolt
    devspec.hw.i2c
    devspec.hw.cpu.intel # Enable kvm-intel
    devspec.hw.cpu.amd # Enable kvm-amd
    devspec.hw.gpu.intel.enable # Enable i915
    devspec.hw.gpu.amd.enable # Enable amdgpu
    devspec.hw.gpu.nvidia.disable # Disable NVIDIA

    (devspec.luks {
      deviceLuksProvides = "luksDevice0";
      deviceLuksOn = "/dev/disk/by-uuid/<uuid>";
    })

    (common.os-builder "x86_64-linux") # OS building configurations
    devspec.locale # Locale
    devspec.watchdog # Watchdog
    # devspec.virtualisation# Virtualisation (QEMU)
    devspec.printer
    devspec.sound # pipeware
    # devspec.fprint # fprintd
    # devspec.battery # power save

    devspec.greet # greetd login
    devspec.terminal # kmscon and more
    # devspec.desk.common # Desktop common
    # devspec.desk.hyprland # Hyprland

    # Enable ONLY IF you are using WSL
    # (devspec.wsl "nixos")

    (common.users "nixos")
    common.basic-software # nvim, zsh, tmux, git and more

    common.optional.ssh
    # common.optional.browsers # cargo and more
    # common.optional.documents # browser applications
    # common.optional.proxy # chafa and more
    # common.optional.localsend # localsend
  ]);
}
