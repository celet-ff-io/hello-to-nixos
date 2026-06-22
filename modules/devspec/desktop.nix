{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.htn3.device.desktop = {
    enable = lib.mkEnableOption ''
      Set this to true to install applications
      which needs Wayland GUI Desktop environment with compositor.
      i.e. input methods.
    '';
  };

  config =
    let
      cfg = config.htn3.device.desktop;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
          fcitx5-pinyin-zhwiki
          fcitx5-gtk
          fcitx5-lua
        ];
      };

      environment.systemPackages = with pkgs; [
        kdePackages.dolphin
        kdePackages.qt6ct
        libsForQt5.qt5ct

        rofi
        waybar
        mako
        wayshot
        grim
        slurp
        pavucontrol
        nwg-look
        wl-clipboard
      ];
    };
}
