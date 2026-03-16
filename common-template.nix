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
  networking.hostName = "nixoshost"; # Define your hostname.

  # =============
  # Options

  shell = {
    autoStartTmux = true; # Auto start tmux
    # Before enable the following 'onLogin', do not forget to uncomment 'pkgs' in the function arguments!
    # onLogin = "${pkgs.coreutils}/bin/timeout 5s ${pkgs.cmatrix}/bin/cmatrix"; # Run once per login
  };
  # tuigreet.greeting = "> Hello to NixOS <"; # Customize with your own ASCII art!
  # terminal.font-size = 13;

  # Enable foot or kitty to run shell in Cage in Wayland
  # instead of kmscon
  # programs.foot.enable = true;
  # terminal.kitty.enable = true;

  # An option to not install Hyprexpo plugin for Hyprland
  # in case that Hyprexpo and Hyprland do not share the same version
  # however building of Hyprexpo usually requires the same version of Hyprland.
  # For installation only,
  # that simply enabling this won't make Hyprexpo work
  # unless you enable it in your `~/.config/hypr/hyprland.conf`.
  # programs.hyprland.plugins.hyprexpo.enable = false;

  # =============

  # Disk parts

  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@"
    ];
  };

  fileSystems."/nix" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@nix"
    ];
  };

  fileSystems."/home" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@home"
    ];
  };

  fileSystems."/boot" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Swap
  swapDevices = [ ];

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
