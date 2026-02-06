# WIFI and Bluetooth
{ config, lib, ... }: {
  boot.kernelModules = [ "iwlwifi" "btusb" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman = lib.mkIf config.hasGui { enable = true; };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
}
