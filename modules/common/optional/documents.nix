{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.optional.documents;
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  environment.systemPackages = with pkgs; [
    chafa
    imagemagick
    ghostscript
    nb
    zk
  ];
}
