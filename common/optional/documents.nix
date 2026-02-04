# Documents
{ config, pkgs, ... }: {
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs;
    [ chafa imagemagick ] ++ (if config.hasGui then [
      libreoffice-qt-fresh
      gimp-with-plugins
    ] else
      [ ]);
}
