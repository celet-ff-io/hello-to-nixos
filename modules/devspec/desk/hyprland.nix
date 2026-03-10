# Hyprland
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hyprland;
  inherit (lib)
    mkOption
    types
    ;
in
{
  options = {
    programs.hyprland.plugins.hyprexpo.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Set this to false to do not install Hyprexpo plugin for Hyprland";
    };
  };

  config = {
    hasGui = lib.mkDefault true;
    hasDesktop = lib.mkDefault true;

    xdg.portal.config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    environment.systemPackages =
      with pkgs;
      [
        hyprpaper
        hyprpicker
        hyprcursor
      ]
      ++ (
        if cfg.plugins.hyprexpo.enable then
          [
            hyprlandPlugins.hyprexpo
          ]
        else
          [ ]
      );
  };
}
