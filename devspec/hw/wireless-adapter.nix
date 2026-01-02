# WIFI and Bluetooth
{...}: {
  boot.kernelModules = [
    "iwlwifi"
    "btusb"
  ];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
}
