{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  cfg = config.htn3.wheelUsers;
in
{
  options.htn3.wheelUsers = {
    list = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "nixos"
      ];
      description = "List of wheel users' names.";
    };
    default = mkOption {
      type = types.str;
      default = if (builtins.length cfg.list > 0) then (builtins.head cfg.list) else "";
      example = "nixos";
      description = "Default wheel user name. Leave empty to use the first user in 'wheelUsers' list.";
    };
  };

  config = lib.mkIf config.htn3.enable {
    assertions = [
      {
        assertion = builtins.length cfg.list > 0;
        message = "You should add at least one user to 'wheelUsers' option.";
      }
      {
        assertion = cfg.default == "" || builtins.elem cfg.default cfg.list;
        message = "Default user '${cfg.firstUser}' is not in the 'wheelUsers' list.";
      }
    ];
    users = {
      users =
        builtins.listToAttrs (
          map (userName: {
            name = userName;
            value = {
              isNormalUser = true;
              linger = true;
              extraGroups = [
                "wheel"
                "tss"
                "networkmanager"
                "libvirtd"
                "kvm"
                "docker"
              ];
              shell = pkgs.zsh;
            };

          }) cfg.list
        )
        // {
          root = {
            shell = pkgs.zsh;
          };
        };

      defaultUserShell = pkgs.bash;
    };

    security.sudo.wheelNeedsPassword = false;

    systemd.tmpfiles.rules = [
      "z /etc/nixos 2775 ${cfg.default} wheel  - -"
      "Z /etc/nixos -    ${cfg.default} wheel  - -"
    ];
  };
}
