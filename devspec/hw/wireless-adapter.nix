# WIFI and Bluetooth
{ ... }: {
  boot.kernelModules = [ "iwlwifi" "btusb" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
}
