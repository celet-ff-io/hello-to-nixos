# Greeter settings
{ config, lib, pkgs, ... }:
let inherit (lib) mkOption types;
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
  };
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = let
            tuigreetCmd = if config.programs.hyprland.enable then
            # Hyprland
              "start-hyprland"
            else if config.terminal.kitty.enable then
            # kitty
              "${pkgs.cage}/bin/cage -- ${pkgs.kitty}/bin/kitty"
            else if config.programs.foot.enable then
            # foot
              "${pkgs.cage}/bin/cage -- ${pkgs.foot}/bin/foot"
            else
            # kmscon
              let
                configDir = pkgs.writeTextFile {
                  name = "kmscon-config";
                  destination = "/kmscon.conf";
                  text = config.services.kmscon.extraConfig;
                };
              in ''
                sh -c "
                if id -nG | grep -qw \"wheel\"; then
                  sudo \
                  ${pkgs.kmscon}/bin/kmscon --vt=1 --seats=seat0 --no-switchvt \
                  --configdir ${configDir} \
                  --login -- ${pkgs.shadow}/bin/login -p -f $(whoami)
                else
                  $SHELL
                fi
                "
              '';
          in ''
            ${pkgs.tuigreet}/bin/tuigreet \
            --greeting '${config.tuigreet.greeting}' \
            --time \
            --remember \
            --asterisks \
            --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red' \
            --cmd '${tuigreetCmd}'
          '';
          user = "greeter";
        };
      };
    };
  };
}
