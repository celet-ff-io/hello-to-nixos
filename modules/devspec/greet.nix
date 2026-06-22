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
  options.htn3.device.greeting = {
    issue = {
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
        description = "Greeting text.";
      };
    };
  };

  config =
    let
      cfg = config.htn3.device.greeting;
    in
    lib.mkIf (with config.htn3; (enable && device.enable)) {
      environment.etc."issue" = mkIf cfg.issue.enable {
        inherit (cfg.issue) text;
      };
      services.greetd = {
        enable = true;
        settings.default_session = {
          user = "greeter";
          command =
            let
              tuigreetCmd =
                if config.htn3.device.hyprland.enable then
                  "start-hyprland"
                else
                  "${pkgs.cage}/bin/cage -- ${config.htn3.device.terminal.startCommand}";
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
        };
      };
    };
}
