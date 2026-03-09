# Network proxy
{ config, lib, pkgs, ... }:
let inherit (lib) mkEnableOption;
in {
  options = { proxy.flclash.enable = mkEnableOption "Use FlClash"; };
  config = {
    # Use mihomo instead
    systemd.tmpfiles.rules = if config.services.mihomo.enable then [
      "d /root/.config/mihomo 2775 root wheel - -"
      "Z /root/.config/mihomo -    root wheel - -"
    ] else
      [ ];
    services.mihomo = {
      configFile = "/root/.config/mihomo/config.yaml";
      webui = pkgs.metacubexd;
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs;
      [ clashtui ] ++ (if config.proxy.flclash.enable then
      # Use FlClash
        [ flclash ]
      else
        [ ]);

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
