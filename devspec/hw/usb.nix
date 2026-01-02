# USB
{pkgs, ...}: {
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
  ];
}
