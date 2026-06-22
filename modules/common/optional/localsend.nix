{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.optional.localsend;
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  environment.systemPackages = with pkgs; [ localsend ];

  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
