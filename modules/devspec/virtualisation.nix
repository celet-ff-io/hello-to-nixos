{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.htn3.device.virtualisation = {
    enable = lib.mkEnableOption ''
      Set this to true to enable virtualisation features.
    '';
  };

  config =
    let
      cfg = config.htn3.device.virtualisation;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) (
      {
        boot.kernelModules = [
          "vfio"
          "vfio_pci"
          "vfio_iommu_type1"
        ];

        environment.systemPackages = with pkgs; [ virtiofsd ];

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
      }
      // lib.mkIf config.htn3.device.gui.enable {
        programs.virt-manager.enable = true;
      }
    );
}
