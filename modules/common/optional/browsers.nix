{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.htn3.optional.browsers;
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  programs.zsh.ohMyZsh.plugins = [ "web-search" ];

  environment.systemPackages = with pkgs; [ w3m ];
}
