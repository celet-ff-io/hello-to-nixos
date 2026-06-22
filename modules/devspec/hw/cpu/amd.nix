{ config, lib, ... }: {
  options.htn3.device.hw.cpu.amd = {
    enable = lib.mkEnableOption ''
      Set this to true to enable features specific to AMD CPUs.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.cpu.amd;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.kernelModules = [ "kvm-amd" ];
      boot.kernelParams = [ "amd_iommu=on" ];
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
