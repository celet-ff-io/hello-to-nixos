{ ... }:
{
  imports = [
    ./commonopts.nix
    ./greet.nix
    ./terminal.nix
    ./misc.nix

    ./gui.nix
    ./desktop.nix
    ./hyprland.nix

    ./luks.nix
    ./fprint.nix
    ./battery.nix
    ./virtualisation.nix

    ./hw
  ];
}
