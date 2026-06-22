{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.optional.proxy;
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  environment.systemPackages = with pkgs; [ clashtui ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
