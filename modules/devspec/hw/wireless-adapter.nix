{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.device.hw.wirelessAdapter;
in
lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
  boot.kernelModules = [
    "iwlwifi"
    "btusb"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    wifitui
  ];
}
