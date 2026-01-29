# Finger print
{ config, lib, ... }: {
  config = {
    services.fprintd.enable = true;

    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      polkit-1 =
        lib.mkIf config.programs.hyprland.enable { fprintAuth = true; };
    };
  };
}
