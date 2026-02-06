# Terminal settings
{ config, lib, pkgs, ... }:
let inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;
in {
  options = {
    terminal = {
      font-size = mkOption { type = types.int; };
      kitty.enable = mkEnableOption "Use Kitty";
    };
    default = 13;
  };

  config = mkMerge [
    {
      console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
      };
      services.kmscon = {
        enable = true;
        hwRender = true;
        fonts = [{
          name = "JetBrainsMono Nerd Font Mono";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }];
        extraConfig = ''
          font-size=${toString config.terminal.font-size}
        '';
      };

      # hardware graphics and nerd-fonts jetbrains-mono have been enabled by kmscon

      # Enable foot by `programs.foot.enable`
      programs.foot = {
        enableZshIntegration = config.programs.zsh.enable;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font Mono:size=${
                toString config.terminal.font-size
              }";
          };
          colors = { background = "000000"; };
        };
      };

      environment.systemPackages = with pkgs;
        mkIf config.terminal.kitty.enable [ kitty ];
    }

    (mkIf (with config; programs.foot.enable || terminal.kitty.enable) {
      hasGui = mkDefault true;
    })
  ];
}
