# TTY specific configs
{pkgs, ...}: {
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
      font-size=18
    '';
    # autologinUser = "nixos";
  };
}
