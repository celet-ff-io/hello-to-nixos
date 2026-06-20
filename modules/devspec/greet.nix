# Greeter settings
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
in
{
  options = {
    greeting = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Set this to overwrite the /etc/issue file with the greeting text.";
      };
      text = mkOption {
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
        description = "Greeting text";
      };
    };
  };
  config = {
    environment.etc."issue" = mkIf config.greeting.enable {
      inherit (config.greeting) text;
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            let
              tuigreetCmd =
                if config.programs.hyprland.enable then
                  # Hyprland
                  "start-hyprland"
                else if config.terminal.kitty.enable then
                  # kitty
                  "${pkgs.cage}/bin/cage -- ${pkgs.kitty}/bin/kitty"
                else
                  # foot
                  "${pkgs.cage}/bin/cage -- ${pkgs.foot}/bin/foot";
              greetdCmdMultiline = ''
                ${pkgs.tuigreet}/bin/tuigreet
                --issue
                --time
                --remember
                --asterisks
                --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'
                --cmd '${tuigreetCmd}'
              '';
            in
            lib.concatStringsSep " " (lib.splitString "\n" greetdCmdMultiline);
          user = "greeter";
        };
      };
    };
  };
}
