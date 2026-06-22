{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.htn3.device.luks = {
    enable = lib.mkEnableOption ''
      Set this to true to enable LUKS support with TPM2 integration.
    '';

    devices = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            provides = mkOption {
              type = types.str;
              description = "The device which LUKS will provide.";
            };
            on = mkOption {
              type = types.str;
              description = "The device which LUKS will use as source.";
            };
          };
        }
      );
      default = [ ];
      example = [
        {
          provides = "luksDevice0";
          on = "/dev/disk/by-uuid/1234";
        }
      ];
      description = "List of LUKS devices to set up with TPM2 integration.";
    };
  };

  config =
    let
      cfg = config.htn3.device.luks;
    in
    lib.mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      boot.initrd = {
        systemd.enable = true;
        availableKernelModules = [
          "tpm_crb"
          "tpm_tis" # Legacy support
        ];

        luks.devices = builtins.listToAttrs (
          map (device: {
            name = device.provides;
            value = {
              device = device.on;
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };
          }) cfg.devices
        );
      };
    };
}
