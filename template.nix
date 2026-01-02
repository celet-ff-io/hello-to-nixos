# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{...}: {
  imports = [
    ./devspec/commonhw.nix
    ./devspec/hw/usb.nix
    ./devspec/hw/wireless-adapter.nix

    (import ./common/os-builder.nix "x86_64-linux")
    ./devspec/locale.nix
    ./devspec/printer.nix
    ./devspec/sound.nix

    (import ./common/users.nix "nixos")
    ./common/basic-software.nix
    ./common/optional/ssh.nix

    ./devspec/gui/desk.nix
    ./devspec/gui/software.nix
  ];

  networking.hostName = "nixoshost"; # Define your hostname.

  tmux.autoStart = true;

  # Main part

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
