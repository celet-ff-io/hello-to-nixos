# Hyprland
{ lib, pkgs, ... }: {
  hasGui = lib.mkDefault true;
  hasDesktop = lib.mkDefault true;

  xdg.portal.config.hyprland = { default = [ "hyprland" "gtk" ]; };

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprpicker
    hyprcursor

    hyprlandPlugins.hyprexpo
  ];
}
