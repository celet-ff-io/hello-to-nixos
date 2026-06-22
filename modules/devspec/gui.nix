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
  options.htn3.device.gui = {
    enable = lib.mkEnableOption ''
      Set this to true to enable wayland features.
    '';
  };

  config =
    let
      htn3Cfg = config.htn3;
      optCfg = htn3Cfg.optional;
      optBrowsersEnable = optCfg.browsers.enable;
      cfg = htn3Cfg.device.gui;
    in
    mkIf (with htn3Cfg; (enable && device.enable) && cfg.enable) {
      # Configure keymap in X11
      services.xserver.xkb.layout = "us";
      # services.xserver.xkb.options = "eurosign:e,caps:escape";

      xdg.portal.enable = true;

      services.dbus.enable = true;

      security.polkit.enable = true;

      programs = mkIf optBrowsersEnable {
        firefox.enable = true;
      };
      environment = lib.mkMerge [
        {
          systemPackages = with pkgs; [ zed-editor ];
          sessionVariables = {
            QT_QPA_PLATFORM = "wayland";
            QT_QPA_PLATFORMTHEME = "qt6ct";
            NIXOS_OZONE_WL = "1";
          };
        }
        (mkIf optBrowsersEnable {
          sessionVariables = {
            BROWSER = lib.mkDefault "firefox";
          };
        })
        (mkIf optCfg.documents.enable {
          systemPackages = with pkgs; [
            libreoffice-qt-fresh
            gimp-with-plugins
          ];
        })
        (mkIf optCfg.proxy.enable {
          systemPackages = with pkgs; [
            flclash
          ];
        })
      ];
    };
}
