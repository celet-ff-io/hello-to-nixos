{ config, lib, ... }: {
  options.htn3.device.hw.gpu.amd = {
    enable = lib.mkEnableOption ''
      Set this to true to enable features specific to AMD GPUs.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.gpu.amd;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.kernelModules = [
        "amdgpu"
      ];
    };
}
