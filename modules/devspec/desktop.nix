{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
in
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
      htn3Cfg = config.htn3;
      cfg = htn3Cfg.device.desktop;
    in
    mkIf (with htn3Cfg; (enable && device.enable) && cfg.enable) {
      xdg.portal.enable = true;

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

      environment = lib.mkMerge [
        {
          systemPackages = with pkgs; [
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
        }
        (mkIf (with htn3Cfg.optional.proxy; enable && enableFlClash) {
          systemPackages = with pkgs; [
            flclash
          ];
        })
      ];
    };
}
