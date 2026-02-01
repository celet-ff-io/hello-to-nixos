# USB
{ ... }: {
  boot.initrd.availableKernelModules = [ "thunderbolt" ];
  services.hardware.bolt.enable = true;
}
