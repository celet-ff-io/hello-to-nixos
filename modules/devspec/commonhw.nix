# Common hardware configs
{ lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;
  boot.kernelParams = [ "iommu=pt" ];
  networking.nftables.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 7;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  boot.initrd.availableKernelModules =
    [ "ahci" "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    lm_sensors
    parted
    usbutils
    pciutils
  ];

  # List services that you want to enable:
  services.thermald.enable = true;
}
