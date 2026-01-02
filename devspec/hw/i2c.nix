# I2C
{...}: {
  boot.initrd.availableKernelModules = [
    "i2c_designware_platform"
    "i2c_designware_core"
    "i2c_hid"
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
