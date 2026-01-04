# Browsers
{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    ohMyZsh = {
      plugins = [
        "web-search"
      ];
    };
  };

  programs.firefox.enable = config.hasGui;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    w3m
  ];

  environment.sessionVariables = {
    BROWSER =
      if config.hasGui
      then "firefox"
      else "w3m";
  };
}
