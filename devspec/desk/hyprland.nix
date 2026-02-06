# Hyprland
{ lib, pkgs, ... }: {
  hasGui = lib.mkDefault true;
  hasDesktop = lib.mkDefault true;

  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

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
