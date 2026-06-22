{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  options.htn3.device.hw.wirelessAdapter = {
    enable = lib.mkEnableOption ''
      Set this to true to enable Wi-Fi and Bluetooth support.
    '';
  };

  config =
    let
      devCfg = config.htn3.device;
      cfg = devCfg.hw.wirelessAdapter;
      guiEnable = devCfg.gui.enable;
    in
    mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
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

      services = mkIf guiEnable { blueman.enable = true; };

      environment = lib.mkMerge [
        {
          systemPackages = with pkgs; [
            wifitui
            bluetuith
          ];
        }
        (mkIf guiEnable {
          systemPackages = with pkgs; [
            overskride
          ];
        })
      ];
    };
}
