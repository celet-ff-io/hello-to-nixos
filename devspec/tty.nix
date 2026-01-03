# TTY specific configs
{
  config,
  pkgs,
  ...
}: let
  greeting = ''
    === Hello to NixOS ===
         ====    ====
  '';
in {
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
      vt=1
      font-size=18
    '';
  };

  # For wheel users only currently,
  services.greetd = {
    enable = true;
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
          --greeting '${greeting}' \
          --time \
          --remember \
          --asterisks \
          --cmd '${pkgs.bash}/bin/sh -c " \
          sudo ${pkgs.kmscon}/bin/kmscon --vt=1 --seats=seat0 --no-reset-env --no-switchvt \
          --configdir ${configDir} \
          --login -- ${pkgs.shadow}/bin/login -p -f $(whoami) \
          "'
        '';
        user = "greeter";
      };
    };
  };
}
