{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.htn3.device.hw.gpu.intel = {
    enable = lib.mkEnableOption ''
      Set this to true to enable features specific to Intel GPUs.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.gpu.intel;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.kernelModules = [
        "i915"
      ];
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
}
