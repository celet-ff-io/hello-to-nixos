{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  options.htn3.device.gui = {
    enable = lib.mkEnableOption ''
      Set this to true to enable wayland features.
    '';
  };

  config =
    let
      cfg = config.htn3.device.gui;
    in
    mkIf (with config.htn3; (enable && device.enable) && cfg.enable) (
      {
        # Configure keymap in X11
        services.xserver.xkb.layout = "us";
        # services.xserver.xkb.options = "eurosign:e,caps:escape";

        xdg.portal.enable = true;

        services.dbus.enable = true;

        security.polkit.enable = true;

        environment.sessionVariables = {
          QT_QPA_PLATFORM = "wayland";
          QT_QPA_PLATFORMTHEME = "qt6ct";
          NIXOS_OZONE_WL = "1";
        };

      }
      // mkIf config.htn3.optional.browsers.enable {
        programs.firefox.enable = true;

        environment.sessionVariables = {
          BROWSER = lib.mkDefault "firefox";
        };
      }
      // mkIf config.htn3.optional.documents.enable {
        environment.systemPackages = with pkgs; [
          libreoffice-qt-fresh
          gimp-with-plugins
        ];
      }
      // mkIf config.htn3.optional.proxy.enable {
        environment.systemPackages = with pkgs; [ flclash ];
      }
      // mkIf config.htn3.device.hw.wireless-adapter.enable {
        services.blueman.enable = true;
      }
    );
}
