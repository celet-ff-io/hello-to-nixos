{ config, lib, ... }: {
  options.htn3.device.hw.cpu.intel = {
    enable = lib.mkEnableOption ''
      Set this to true to enable features specific to Intel CPUs.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.cpu.intel;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.kernelModules = [ "kvm-intel" ];
      boot.kernelParams = [ "intel_iommu=on" ];
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
