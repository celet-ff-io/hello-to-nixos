# USB
{...}: {
  boot.initrd.availableKernelModules = [
    "thunderbolt"
  ];
  boot.kernelParams = [
    "iommu=pt"
  ];
  services.hardware.bolt.enable = true;
}
