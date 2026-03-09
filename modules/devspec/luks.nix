# LUKS
{
  deviceLuksProvides,
  deviceLuksOn,
}: {...}: {
  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices.${deviceLuksProvides} = {
    device = deviceLuksOn;
    crypttabExtraOpts = ["tpm2-device=auto"];
  };

  boot.initrd.availableKernelModules = [
    "tpm_crb"
    "tpm_tis" # Legacy support
  ];
}
