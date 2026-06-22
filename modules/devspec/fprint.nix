{ config, lib, ... }: {
  options.htn3.device.fprint = {
    enable = lib.mkEnableOption ''
      Set this to true to enable fingerprint authentication.
    '';
  };

  config =
    let
      cfg = config.htn3.device.fprint;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      services.fprintd.enable = true;

      security.pam.services = {
        login.fprintAuth = true;
        sudo.fprintAuth = true;
        polkit-1 = lib.mkIf config.programs.hyprland.enable { fprintAuth = true; };
      };
    };
}
