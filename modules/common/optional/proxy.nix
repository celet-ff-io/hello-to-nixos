{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.htn3.optional.proxy;
in
mkIf (config.htn3.enable && cfg.enable) {
  environment.systemPackages = with pkgs; [ clashtui ];

  services = mkIf cfg.mihomo.enable {
    mihomo = {
      enable = true;
      tunMode = true;
      inherit (cfg.mihomo) configFile;
      webui = lib.mkDefault pkgs.metacubexd;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
