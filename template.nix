# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
  # pkgs,
  ...
}: {
  imports = [
    ./devspec/commonhw.nix # systemd boot
    ./devspec/hw/usb.nix
    ./devspec/hw/wireless-adapter.nix
    # ./devspec/hw/thunderbot.nix
    # ./devspec/hw/i2c.nix
    # ./devspec/hw/cpu/intel.nix # Enable kvm-intel
    # ./devspec/hw/cpu/amd.nix # Enable kvm-amd
    # ./devspec/hw/gpu/intel # Enable i915
    # ./devspec/hw/gpu/amd # Enable amdgpu
    # ./devspec/hw/gpu/nvidia/disable.nix # Disable NVIDIA
    # (import ./devspec/luks.nix {
    #   deviceLuksProvides = "luksDevice0";
    #   deviceLuksOn = "/dev/disk/by-uuid/<uuid>";
    # })

    (import ./common/os-builder.nix "x86_64-linux") # Experimental features and mirrors
    ./devspec/locale.nix # Timezone and language
    ./devspec/printer.nix
    ./devspec/sound.nix # pipeware
    # ./devspec/fprint.nix # fprintd
    # ./devspec/battery.nix # power save

    ./devspec/greet.nix # greetd login
    ./devspec/terminal.nix # kmscon and more
    # ./devspec/desk/ # Currently useless

    (import ./common/users.nix "nixos")
    ./common/basic-software.nix # nvim, zsh, tmux, git and more
    ./common/optional/ssh.nix
    # ./common/optional/developer.nix # cargo and more
    # ./common/optional/browsers.nix # w3m and more
    # ./common/optional/documents.nix # chafa and more
    # ./common/optional/proxy.nix # mihomo and more

    # ./userspec/example.nix  # your config in extra files
  ];

  networking.hostName = "nixoshost"; # Define your hostname.

  # =============
  # Options

  shell = {
    autoStartTmux = true; # Auto start tmux
    # onLogin = "${pkgs.coreutils}/bin/timeout 5s ${pkgs.cmatrix}/bin/cmatrix"; # Run once per login
  };
  # tuigreet.greeting = "> Hello to NixOS <"; # Customize with your own ASCII art!
  # terminal.font-size = 13;

  # Enable foot or kitty to run shell in Cage in Wayland
  # instead of kmscon
  # programs.foot.enable = true;
  # terminal.kitty.enable = true;

  # =============

  # Disk parts

  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/home" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/nix" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  # EFI
  fileSystems."/boot" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # Swap
  swapDevices = [];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
