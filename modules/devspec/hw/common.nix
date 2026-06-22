{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (with config.htn3; (enable && device.enable)) {
  hardware.enableAllFirmware = true;

  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  environment.systemPackages = with pkgs; [
    lm_sensors
    parted
    usbutils
    pciutils
  ];

  # List services that you want to enable:
  services.thermald.enable = true;
}
