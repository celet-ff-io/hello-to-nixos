# TTY specific configs
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  options = {
    tuigreet.greeting = mkOption {
      type = types.lines;
      default = ''
        v<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        v                                                                          ^
        v                           ####       ######    ###                       ^
        v                          #####       #####   ####                        ^
        v                           #####       ##### ####                         ^
        v                            #####       ########                          ^
        v                     ##################  ######     ##                    ^
        v                    ####################  ####     ####                   ^
        v   _    _      _ _         ### _           ###_   _ _      ____   _____   ^
        v  | |  | |    | | |########## | |           #| \ | (_) ###/ __ \ / ____|  ^
        v  | |__| | ___| | |#___  #### | |_ ___       |  \| |_  __| |  | | (___    ^
        v  |  __  |/ _ \ | |/ _ \ ###  | __/ _ \      | . ` | |/ _` |  | |\___ \   ^
        v  | |  | |  __/ | | (_) | #   | || (_) |     | |\  | | (#| |__| |____) |  ^
        v  |_|  |_|\___|_|_|\___/ #     \__\___/     #|_| \_|_|\__,_|\__/|_____/   ^
        v                       ##                  ##                             ^
        v                    ####                  ####                            ^
        v                    ####     ##  #####################                    ^
        v                     ####   ####  ###################                     ^
        v                           #######       #####                            ^
        v                          ##### #####     #####                           ^
        v                         #####   #####     #####                          ^
        v                         ####     ####      ####                          ^
        v                                                                          ^
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>^

      '';
      description = "Greeting message for tuigreet";
    };
    kmscon.font-size = mkOption {
      type = types.int;
      default = 12;
    };
  };
  config = {
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    services.kmscon = {
      enable = true;
      hwRender = true;
      fonts = [
        {
          name = "JetBrainsMono Nerd Font Mono";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
      extraConfig = ''
        font-size=${toString config.kmscon.font-size}
      '';
    };

    # For wheel users only currently.
    # Enable this with `services.greetd.enable`
    services.greetd = {
      settings = {
        default_session = {
          command = let
            configDir = pkgs.writeTextFile {
              name = "kmscon-config";
              destination = "/kmscon.conf";
              text = config.services.kmscon.extraConfig;
            };
          in ''
            ${pkgs.tuigreet}/bin/tuigreet \
            --greeting '${config.tuigreet.greeting}' \
            --time \
            --remember \
            --asterisks \
            --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red' \
            --cmd 'sudo \
            ${pkgs.kmscon}/bin/kmscon --vt=1 --seats=seat0 --no-switchvt \
            --configdir ${configDir} \
            --login -- ${pkgs.shadow}/bin/login -p -f $(whoami) \
            '
          '';
          user = "greeter";
        };
      };
    };
  };
}
