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
      vt=1
      font-size=18
    '';
    # autologinUser = "nixos";
  };
}
