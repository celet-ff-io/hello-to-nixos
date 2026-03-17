{
  description = "Hello to NixOS II in Flakes";

  outputs =
    { ... }:
    {
      nixosModules = {
        common = {
          os-builder = hostPlatform: import ./modules/common/os-builder.nix hostPlatform;
          users = userName: import ./modules/common/users.nix userName;
          basic-software = ./modules/common/basic-software.nix;
        };

        devspec = {
          commonhw = ./modules/devspec/commonhw.nix;
          hw = {
            wireless-adapter = ./modules/devspec/hw/wireless-adapter.nix;
            thunderbolt = ./modules/devspec/hw/thunderbolt.nix;
            i2c = ./modules/devspec/hw/i2c.nix;
            cpu = {
              intel = ./modules/devspec/hw/cpu/intel.nix;
              amd = ./modules/devspec/hw/cpu/amd.nix;
            };
            gpu = {
              intel.enable = ./modules/devspec/hw/gpu/intel/default.nix;
              amd.enable = ./modules/devspec/hw/gpu/amd/default.nix;
              nvidia.enable = ./modules/devspec/hw/gpu/nvidia/default.nix;
              nvidia.disable = ./modules/devspec/hw/gpu/nvidia/disable.nix;
            };
          };

          luks =
            { deviceLuksProvides, deviceLuksOn }:
            import ./modules/devspec/luks.nix {
              deviceLuksProvides = deviceLuksProvides;
              deviceLuksOn = deviceLuksOn;
            };

          locale = ./modules/devspec/locale.nix;
          watchdog = ./modules/devspec/watchdog.nix;
          printer = ./modules/devspec/printer.nix;
          sound = ./modules/devspec/printer.nix;
          fprint = ./modules/devspec/fprint.nix;
          battery = ./modules/devspec/battery.nix;

          greet = ./modules/devspec/greet.nix;
          terminal = ./modules/devspec/terminal.nix;

          desk = {
            common = ./modules/devspec/desk/common.nix;
            hyprland = ./modules/devspec/desk/hyprland.nix;
          };

          virtualisation = ./modules/devspec/virtualisation.nix;

          wsl = defaultUser: import ./modules/devspec/wsl.nix defaultUser;
        };

        common.optional = {
          ssh = ./modules/common/optional/ssh.nix;
          developer = ./modules/common/optional/developer.nix;
          browsers = ./modules/common/optional/browsers.nix;
          documents = ./modules/common/optional/documents.nix;
          proxy = ./modules/common/optional/proxy.nix;
          localsend = ./modules/common/optional/localsend.nix;
        };
        # Import them all
        common.optional.default = ./modules/common/optional/default.nix;
      };
    };
}
