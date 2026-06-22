{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
in
{
  options.htn3.device.virtualisation = {
    enable = lib.mkEnableOption ''
      Set this to true to enable virtualisation features.
    '';
  };

  config =
    let
      devCfg = config.htn3.device;
      cfg = devCfg.virtualisation;
    in
    mkIf (with config.htn3; (enable && device.enable) && cfg.enable) ({
      boot.kernelModules = [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_full.override {
            cephSupport = false;
          };
          swtpm.enable = true;
          verbatimConfig = ''
            namespaces = []
            seccomp_sandbox = 0
          '';
        };
      };

      programs = mkIf devCfg.gui.enable {
        virt-manager.enable = true;
      };

      environment.systemPackages = with pkgs; [ virtiofsd ];
    });
}
