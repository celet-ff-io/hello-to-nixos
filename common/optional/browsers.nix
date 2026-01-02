# Browsers
{pkgs, ...}: {
  programs.zsh = {
    ohMyZsh = {
      plugins = [
        "web-search"
      ];
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    w3m
  ];

  environment.sessionVariables = {
    BROWSER = "w3m";
  };
}
