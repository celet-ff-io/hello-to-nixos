{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.htn3.device.hyprland = {
    enable = lib.mkEnableOption ''
      Enable Hyprland and related applications.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hyprland;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      htn3.device = {
        gui.enable = lib.mkDefault true;
        desktop.enable = lib.mkDefault true;
      };

      xdg.portal.config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };

      programs = {
        hyprland.enable = true;
        hyprlock.enable = true;
      };

      services.hypridle.enable = true;
      environment.systemPackages = with pkgs; [
        hyprpaper
        hyprpicker
        hyprcursor
        grimblast
      ];
    };
}
