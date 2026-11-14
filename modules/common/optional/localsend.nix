{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.htn3.optional.localsend;
  # TODO: remove when nixpkgs.me carries upstream #585411 (localsend zlib fix)
  localsend = pkgs.localsend.overrideAttrs (old: {
    runtimeDependencies = [ pkgs.zlib ];
  });
in
lib.mkIf (config.htn3.enable && cfg.enable) {
  environment.systemPackages = [ localsend ];

  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
}
