# TTY specific configs
{pkgs, ...}: let
  greeting = ''
    === Welcome to Nix OS ===
          ===      ===
  '';
in {
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   fonts = [
  #     {
  #       name = "JetBrainsMono Nerd Font Mono";
  #       package = pkgs.nerd-fonts.jetbrains-mono;
  #     }
  #   ];
  #   extraConfig = ''
  #     vt=1
  #     font-size=18
  #     hwaccel
  #   '';
  #   # autologinUser = "nixos";
  # };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.kmscon}/bin/kmscon "--vt=1" --seats=seat0 --no-reset-env --no-switchvt --login -- ${pkgs.tuigreet}/bin/tuigreet --greeting "${greeting}" --time --remember --asterisks --cmd $SHELL
        '';
        user = "root";
      };
    };
  };
}
