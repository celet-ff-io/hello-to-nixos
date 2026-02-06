# Virtualisation
{ pkgs, ... }: {
  boot.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
  environment.systemPackages = with pkgs; [ virtiofsd ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_full;
      swtpm.enable = true;
      verbatimConfig = ''
        namespaces = []
        seccomp_sandbox = 0
      '';
    };
  };
}
