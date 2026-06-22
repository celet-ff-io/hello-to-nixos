{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    ;
  cfg = config.htn3;
in
mkIf cfg.enable {
  programs = {
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = mkDefault pkgs.pinentry-curses;
    };
  };

  environment = {
    localBinInPath = true;

    shellAliases = {
      rebs = "nixos-rebuild switch --flake";
      edit = "$EDITOR";
      ls = "eza --icons=auto";
      ll = "eza --icons=auto -l";
      la = "eza --icons=auto -lAh";
      l = "eza --icons=auto -alh";
      tree = "eza --icons=auto -T";
      cat = "bat --paging=never";
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    systemPackages = with pkgs; [
      fastfetch
      file
      tree
      duf
      dust
      htop
      bottom
      btop
      psmisc
      procs

      trash-cli
      wget
      curl
      zip
      unzip
      gnupg
      git-crypt
      openssl
      openssh
      appimage-run

      bat
      eza
      ripgrep
      fd
      fzf
      jq

      lazygit
      (nnn.override { withNerdIcons = true; })
      yazi
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];

    sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
      VISUAL = lib.mkDefault "nvim";

      NNN_PLUG = "e:suedit;p:preview-tui";
      NNN_PLUGINS = "{nnnSrc}/plugins";
      NNN_OPTS = "e";

      ZSH_TMUX_AUTOREFRESH = "true";
      ZSH_TMUX_AUTOQUIT = "false";
      ZSH_TMUX_DEFAULT_SESSION_NAME = "main";
    };
  };

  programs = {
    gnupg.agent = {
      enableSSHSupport = true;
    };
    mosh.enable = true;
  };
}
