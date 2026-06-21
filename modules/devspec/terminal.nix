# Terminal settings
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
in
{
  options = {
    terminal = {
      font-size = mkOption {
        type = types.int;
        default = 13;
        description = "Font size for terminal emulators.";
      };
      kitty.enable = mkEnableOption "Use Kitty.";
    };
  };

  config = mkMerge [
    {
      console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
      };

      fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

      services.kmscon = {
        enable = true;
        config = {
          inherit (config.terminal) font-size;
          font-name = "JetBrainsMono Nerd Font Mono";
          hwaccel = true;
        };
      };

      # hardware graphics and nerd-fonts jetbrains-mono have been enabled by kmscon

      # Enable foot by `programs.foot.enable`
      programs.foot = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font Mono:size=${toString config.terminal.font-size}";
          };
          colors = {
            background = "000000";
          };
        };
      };

      environment.systemPackages = with pkgs; mkIf config.terminal.kitty.enable [ kitty ];
    }

    (mkIf (with config; programs.foot.enable || terminal.kitty.enable) {
      hasGui = mkDefault true;
    })
  ];
}
