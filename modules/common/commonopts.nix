{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.htn3 = {
    enable = mkEnableOption "Enable HTN3 common configuration.";

    optional = {
      enableAll = mkEnableOption "Enable all optional configurations.";

      browsers.enable = mkEnableOption "Enable browser configuration.";
      developer.enable = mkEnableOption "Enable developer configuration.";
      documents.enable = mkEnableOption "Enable documents configuration.";
      localsend.enable = mkEnableOption "Enable localsend configuration.";
      proxy.enable = mkEnableOption "Enable proxy configuration.";
      sshd.enable = mkEnableOption "Enable sshd configuration.";
    };
  };

  config =
    let
      cfg = config.htn3;
    in
    mkIf (cfg.enable && cfg.optional.enableAll) {
      htn3.optional = {
        browsers.enable = mkDefault true;
        developer.enable = mkDefault true;
        documents.enable = mkDefault true;
        localsend.enable = mkDefault true;
        proxy.enable = mkDefault true;
        sshd.enable = mkDefault true;
      };
    };
}
