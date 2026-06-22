{ config, lib, ... }:
{
  options.htn3.device.hw.thunderbolt = {
    enable = lib.mkEnableOption ''
      Set this to true to enable Thunderbolt support.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.thunderbolt;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.initrd.availableKernelModules = [ "thunderbolt" ];
      services.hardware.bolt.enable = true;
    };
}
