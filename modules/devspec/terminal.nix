{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  cfg = config.htn3.device.terminal;
in
{
  options.htn3.device.terminal = {
    font-size = mkOption {
      type = types.int;
      default = 13;
      description = "Font size for terminal emulators.";
    };

    useKitty = lib.mkEnableOption ''
      Set this to true to use kitty instead of foot when no desktop.
    '';

    startCommand = mkOption {
      type = types.str;
      default = if cfg.useKitty then "${pkgs.kitty}/bin/kitty" else "${pkgs.foot}/bin/foot";
      description = "Default terminal emulator to use when no desktop environment.";
    };
  };

  config = mkIf (with config.htn3; (enable && device.enable)) (
    {
      console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
      };

      services.kmscon = {
        enable = true;
        config = {
          inherit (cfg) font-size;
          font-name = "JetBrainsMono Nerd Font Mono";
          hwaccel = true;
        };
      };

      htn3.device.gui.enable = lib.mkDefault true;

      programs.foot = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font Mono:size=${lib.toString cfg.font-size}";
          };
          colors = {
            background = "000000";
          };
        };
      };
    }
    // mkIf cfg.useKitty {
      environment.systemPackages = with pkgs; [ kitty ];
    }
  );
}
