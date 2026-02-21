# Basic softwares
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkEnableOption mkOption types;
  nnnSrc = pkgs.nnn.src;
  nnnMisc = "${nnnSrc}/misc";

  tmuxConnectivityStatusDir = pkgs.writeTextFile {
    name = "tmux-connectivity-status";
    text = ''
      #!/bin/sh
      # Use nmcli to check connectivity state
      state=$(nmcli -t -f CONNECTIVITY general 2>/dev/null | tr -d '\n')
      case "$state" in
        full) printf "#[bg=green] 󰖟 #[default]" ;;
        limited) printf "#[bg=yellow] !󰖟 #[default]" ;;
        none|"") printf "#[bg=red] X󰖟 #[default]" ;;
        *) printf "󰖟=$state" ;;
      esac
    '';
    executable = true;
    destination = "/bin/tmux-connectivity-status";
  };
in {
  options = {
    hasGui = mkEnableOption ''
      Set this to true if has GUI environment like Wayland.
    '';
    hasDesktop = mkEnableOption ''
      Set this to true if has GUI desktop envronment with compositor.
    '';

    tmux = {
      status.battery = mkOption {
        type = types.str;
        default = "";
        description = "Battery status";
      };
    };

    shell = {
      autoStartTmux = mkEnableOption "Auto start tmux";

      onLogin = mkOption {
        type = types.lines;
        default = "";
        description = "Run once per login";
      };
    };
  };

  config = {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ catppuccin yank resurrect ];
      extraConfig = ''
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind -r H resize-pane -L 1
        bind -r J resize-pane -D 1
        bind -r K resize-pane -U 1
        bind -r L resize-pane -R 1
        set -g status-right '#(${tmuxConnectivityStatusDir}/bin/tmux-connectivity-status)${config.tmux.status.battery} #[bg=default,fg=default]  %H:%M %Y/%m/%d'


        set -g @catppuccin_flavor 'mocha'

        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '15'
      '';
    };

    programs.zsh = {
      enable = true;

      ohMyZsh = {
        enable = true;
        plugins = [ "git" "z" "tmux" "extract" "web-search" "sudo" ];
      };

      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;

      interactiveShellInit = let
        tmuxOrNot = let
          inSess = ''
            fastfetch
          '';
        in with config.shell;
        if autoStartTmux then ''
          # Do not run `inSess` twice
          if [ -n "${"$"}{TMUX:-}" ]; then
            ${inSess}
          else
            ${onLogin}
            to $ZSH_TMUX_DEFAULT_SESSION_NAME
          fi
        '' else ''
          if [ -z "${"$"}{TMUX:-}" ]; then
            ${onLogin}
          fi
          ${inSess}
        '';
      in ''
        function zvm_config() {
          ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
        }

        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d "" cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }

        _QUITCD="${nnnMisc}/quitcd/quitcd.bash_sh_zsh"
        if [ -f "$_QUITCD" ]; then
          source "$_QUITCD"
        fi
        unset _QUITCD

        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # Alias
        alias to='tmux new-session -A -s'
        alias rebuild='sudo nixos-rebuild switch'

        # Environment
        export PATH="$PATH:$HOME/.local/bin"

        ${tmuxOrNot}
      '';
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.mtr.enable = true;

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = mkDefault pkgs.pinentry-curses;
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs;
      [
        fastfetch
        htop
        duf
        psmisc

        wget
        curl
        zip
        unzip
        gnupg
        git-crypt
        appimage-run

        trash-cli
        ripgrep
        fd
        fzf
        jq
        bat

        (nnn.override { withNerdIcons = true; })
        yazi
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      ] ++ (if config.hasGui then [ zed-editor ] else [ ]);

    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";

      NNN_PLUG = "e:suedit;p:preview-tui";
      NNN_PLUGINS = "{nnnSrc}/plugins";
      NNN_OPTS = "e";

      ZSH_TMUX_AUTOREFRESH = "true";
      ZSH_TMUX_AUTOQUIT = "false";
      ZSH_TMUX_DEFAULT_SESSION_NAME = "main";
    };
  };
}
