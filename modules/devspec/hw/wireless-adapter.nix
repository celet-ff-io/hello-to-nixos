{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.htn3.device.hw.wirelessAdapter;
in
{
  options.htn3.device.hw.wirelessAdapter = {
    enable = lib.mkEnableOption ''
      Set this to true to enable Wi-Fi and Bluetooth support.
    '';
  };

  config = mkIf (with config.htn3; (enable && device.enable) && cfg.enable) (
    {
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
        bluetuith
      ];
    }
    // mkIf config.htn3.device.gui.enable {
      services.blueman.enable = true;
      environment.systemPackages = with pkgs; [
        overskride
      ];
    }
  );
}
