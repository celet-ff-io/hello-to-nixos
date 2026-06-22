# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
  # pkgs,
  ...
}:
{
  # Host name should be same to the one defined in `flake.nix` for this machine
  networking.hostName = "nixoshost"; # Define your hostname.
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  # nix.settings.auto-optimise-store = true;

  # # Enable CUPS to print documents.
  # services.printing.enable = true;

  # =============

  # HTN3 Options

  htn3 = {
    enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    wheelUsers.list = [ "nixos" ];

    shell = {
      autoStartTmux = true; # Auto start tmux

      # # Before enable the following 'onLogin', do not forget to uncomment 'pkgs' in the function arguments!
      # onLogin = "${pkgs.coreutils}/bin/timeout 5s ${pkgs.cmatrix}/bin/cmatrix"; # Run once per login
    };

    optional = {
      # # Or use `.enableAll` to enable all of them
      # browsers.enable = true;
      # developer.enable = true;
      # documents.enable = true;
      # localsend.enable = true;
      # proxy.enable = true;
      # sshd.enable = true;
    };

    # Should set only when using a real Linux device
    device = {
      enable = true;

      terminal = {
        font-size = 13;
        useKitty = true; # Enable kitty to run shell in Cage in Wayland instead of foot
      };

      hyprland.enable = true; # Enable Hyprland desktop

      # fprint.enable = true; # Enable fprintd
      luks = {
        enable = true;
        devices = [
          {
            provides = "luksDevice0";
            on = "/dev/disk/by-uuid/<uuid>";
          }
        ];
      };
      battery.enable = true; # Enable battery features
      # virtualisation.enable = true; # Enable virtualisation (QEMU)

      hw = {
        wirelessAdapter.enable = true; # Enable wireless adapter support
        thunderbolt.enable = true; # Enable Thunderbolt support
        i2c.enable = true; # Enable I2C support
        cpu.amd.enable = true; # Enable kvm-amd
        # cpu.intel.enable = true; # Enable kvm-intel
        gpu.amd.enable = true; # Enable amdgpu
        # gpu.intel.enable = true; # Enable i915
        # gpu.nvidia.enable = true; # Enable nvidia
        # gpu.nvidia.forceUnload = true; # Fully disable nvidia if you have hybrid graphics
      };
    };
  };

  # =============

  # # WSL settings

  # wsl = {
  #   enable = true;
  #   defaultUser = "nixos";
  # };

  # =============

  # Disk parts

  fileSystems = {
    "/" = {
      # device = "/dev/disk/by-uuid/<uuid>";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@"
      ];
    };

    "/nix" = {
      # device = "/dev/disk/by-uuid/<uuid>";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@nix"
      ];
    };

    "/home" = {
      # device = "/dev/disk/by-uuid/<uuid>";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@home"
      ];
    };

    "/boot" = {
      # device = "/dev/disk/by-uuid/<uuid>";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  # Swap
  swapDevices = [ ];

  zramSwap.enable = true;

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
