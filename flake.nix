{
  description = "Hello to NixOS III";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
    in
    {
      nixosModules = {
        default = ./modules;

        common = ./modules/common;
        devspec = ./modules/devspec;
        wsl = ./modules/wsl.nix;
      };

      nixosConfigurations = {
        default = lib.nixosSystem {
          # Like `./examples/flake.nix`
          system = "x86_64-linux";
          modules = [
            self.nixosModules.default
            sops-nix.nixosModules.sops
            "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
            (
              # Like `./examples/common.nix`
              {
                config,
                lib,
                pkgs,
                ...
              }:
              {
                system.stateVersion = "26.11";
                fileSystems."/" = {
                  fsType = "tmpfs";
                  device = "/dev/null";
                };
                boot.loader.grub.enable = false;

                htn3 = {
                  enable = true;
                  wheelUsers.list = [ "nixos" ];
                  shell = {
                    autoStartTmux = true;
                    onLogin = "${pkgs.coreutils}/bin/timeout 5s ${pkgs.cmatrix}/bin/cmatrix";
                  };

                  device = {
                    terminal = {
                      font-size = 13;
                      useKitty = true;
                    };

                    hyprland.enable = true;

                    fprint.enable = true;
                    luks = {
                      enable = true;
                      devices = [
                        {
                          provides = "luksDevice0";
                          on = "/dev/disk/by-uuid/<uuid>";
                        }
                      ];
                    };
                    battery.enable = true;
                    virtualisation.enable = true;

                    hw = {
                      wirelessAdapter.enable = true;
                      thunderbolt.enable = true;
                      i2c.enable = true;
                      cpu = {
                        amd.enable = true;
                        intel.enable = true;
                      };
                      gpu = {
                        amd.enable = true;
                        intel.enable = true;
                        nvidia.enable = true;
                        nvidia.forceUnload = true;
                      };
                    };
                  };
                };
              }
            )
          ];
        };
      };
    };
}
