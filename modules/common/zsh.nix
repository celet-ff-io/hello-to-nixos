{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.htn3.shell = {
    autoStartTmux = mkEnableOption "Auto start tmux.";

    onLogin = mkOption {
      type = types.lines;
      default = "";
      description = "Script which runs once per login.";
    };
  };

  config.programs.zsh =
    let
      cfg = config.htn3.shell;
    in
    mkIf config.htn3.enable {
      enable = true;

      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "z"
          "tmux"
          "extract"
          "web-search"
          "sudo"
        ];
      };

      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;

      interactiveShellInit =
        let
          zvmScript = ''
            function zvm_config() {
              ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
            }
          '';
          yaziScript = ''
            function y() {
              local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
              command yazi "$@" --cwd-file="$tmp"
              IFS= read -r -d "" cwd < "$tmp"
              [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
              rm -f -- "$tmp"
            }
          '';
          nnnScript = ''

            _QUITCD="${pkgs.nnn.src}/misc/quitcd/quitcd.bash_sh_zsh"
            if [ -f "$_QUITCD" ]; then
              source "$_QUITCD"
            fi
            unset _QUITCD
          '';
          interactiveAliases = ''
            # Alias only for interactive users
            alias to='tmux new-session -A -s'
          '';
          startupScript =
            let
              inSess = ''
                ${pkgs.fastfetch}/bin/fastfetch
              '';
            in
            with cfg;
            if autoStartTmux then
              ''
                # Do not run `inSess` twice
                if [ -n "${"$"}{TMUX:-}" ]; then
                  ${inSess}
                else
                  ${onLogin}
                  to $ZSH_TMUX_DEFAULT_SESSION_NAME
                fi
              ''
            else
              ''
                if [ -z "${"$"}{TMUX:-}" ]; then
                  ${onLogin}
                fi
                ${inSess}
              '';
        in
        ''
          ${zvmScript}
          ${yaziScript}
          ${nnnScript}

          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

          ${interactiveAliases}
          ${startupScript}
        '';
    };
}
