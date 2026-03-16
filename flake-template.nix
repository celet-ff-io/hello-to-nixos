{
  description = "Hello-to-NixOS template configuration";

  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    hello-to-nixos = {
      url = "git+file:/path/to/hello-to-nixos";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      hello-to-nixos,
      ...
    }:
    {
      nixosConfigurations."nixoshost" = nixpkgs.lib.nixosSystem {
        modules = [
          (import "${hello-to-nixos}/modules/devspec/commonhw.nix") # systemd boot
          (import "${hello-to-nixos}/modules/devspec/hw/wireless-adapter.nix")
          (import "${hello-to-nixos}/modules/devspec/hw/thunderbolt.nix")
          (import "${hello-to-nixos}/modules/devspec/hw/i2c.nix")
          (import "${hello-to-nixos}/modules/devspec/hw/cpu/intel.nix") # Enable kvm-intel
          (import "${hello-to-nixos}/modules/devspec/hw/gpu/nvidia") # Enable NVIDIA
          (import "${hello-to-nixos}/modules/devspec/luks.nix" {
            deviceLuksProvides = "cryptroot";
            deviceLuksOn = "/dev/disk/by-uuid/926b1085-41a7-48be-821d-4c2eca5ced26";
          })

          (import "${hello-to-nixos}/modules/common/os-builder.nix" "x86_64-linux") # Experimental features and mirrors
          (import "${hello-to-nixos}/modules/devspec/locale.nix") # Timezone and language
          (import "${hello-to-nixos}/modules/devspec/watchdog.nix") # Watchdog
          (import "${hello-to-nixos}/modules/devspec/printer.nix")
          (import "${hello-to-nixos}/modules/devspec/sound.nix") # pipeware
          (import "${hello-to-nixos}/modules/devspec/fprint.nix") # fprintd

          (import "${hello-to-nixos}/modules/devspec/greet.nix") # greetd login
          (import "${hello-to-nixos}/modules/devspec/terminal.nix") # kmscon and more
          (import "${hello-to-nixos}/modules/devspec/desk/common.nix") # Desktop common
          (import "${hello-to-nixos}/modules/devspec/desk/hyprland.nix") # Hyprland
          (import "${hello-to-nixos}/modules/devspec/virtualisation.nix") # Virtualisation (QEMU)

          (import "${hello-to-nixos}/modules/common/users.nix" "nixos")
          (import "${hello-to-nixos}/modules/common/basic-software.nix") # nvim, zsh, tmux, git and more
          (import "${hello-to-nixos}/modules/common/optional")

          ./configuration.nix

          ./userspec/misc.nix
          ./userspec/cs9711.nix
          ./userspec/develop.nix
          ./userspec/ocean.nix
          ./userspec/steam.nix
          ./userspec/waydroid.nix
          ./userspec/netnode.nix
          ./userspec/neo4j.nix
        ];
      };
    };
}
