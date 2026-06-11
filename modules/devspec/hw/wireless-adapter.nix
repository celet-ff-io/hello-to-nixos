# WIFI and Bluetooth
{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [
    "iwlwifi"
    "btusb"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman = lib.mkIf config.hasGui { enable = true; };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    wifitui
  ];
}
