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

  tmux-connectivity-status = pkgs.writeShellApplication {
    name = "tmux-connectivity-status";
    runtimeInputs = with pkgs; [
      coreutils
      networkmanager
    ];
    text = ''
      state=$(nmcli -t -f CONNECTIVITY general 2>/dev/null | tr -d '\n')
      case "$state" in
        full) printf "#[bg=green] 󰖟 #[default]" ;;
        limited) printf "#[bg=yellow] !󰖟 #[default]" ;;
        none|"") printf "#[bg=red] X󰖟 #[default]" ;;
        *) printf "󰖟=$state" ;;
      esac
    '';
    destination = "/bin/tmux-connectivity-status";
  };
in
{
  options.htn3.tmux = {
    status = {
      network-connectivity.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Set this to false to disable network connectivity check in tmux status bar";
      };
      battery.enable = mkEnableOption "Show battery status in tmux status bar";
    };
  };

  config.programs.tmux =
    let
      cfg = config.htn3.tmux;
      statusCfg = cfg.status;
    in
    mkIf config.htn3.enable {
      enable = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
        yank
        resurrect
      ];
      extraConfig =
        let
          setConnectivity =
            if statusCfg.network-connectivity.enable then
              "#(${tmux-connectivity-status}/bin/tmux-connectivity-status)"
            else
              "";
          batteryFormat =
            if statusCfg.battery.enable then
              "#{battery_color_bg} #{battery_icon} #{battery_percentage} 󱧥 #{battery_remain}"
            else
              "";
        in
        ''
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind -r H resize-pane -L 1
          bind -r J resize-pane -D 1
          bind -r K resize-pane -U 1
          bind -r L resize-pane -R 1

          set -g status-right '${setConnectivity}${batteryFormat} #[bg=default,fg=default]  %H:%M %Y/%m/%d'

          set -g @catppuccin_flavor 'mocha'

          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'

          set -s set-clipboard on
          set -g mouse on
        '';
    };
}
