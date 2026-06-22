{ config, lib, ... }: {
  options.htn3.device.hw.i2c = {
    enable = lib.mkEnableOption ''
      Set this to true to enable I2C support.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.i2c;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.initrd.availableKernelModules = [
        "i2c_designware_platform"
        "i2c_designware_core"
        "i2c_hid"
      ];

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;
    };
}
