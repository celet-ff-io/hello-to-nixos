{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.htn3 = {
    device = {
      enable = mkEnableOption ''
        Set this to true to enable features which depends on a real device.
      '';
    };
  };
}
