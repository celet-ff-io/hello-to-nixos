{
  description = "Hello-to-NixOS template configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Or from local:
    # nixpkgs.url = "git+file:///path/to/nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Required if you are using WSL
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follow = "nixpkgs";
    # };

    hello-to-nixos.url = {
      url = "github:celet-ff-io/hello-to-nixos";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
      sops-nix.follows = "sops-nix";
    };
  };

  outputs =
    {
      nixpkgs,
      sops-nix,
      # nixos-wsl, # Required if you are using WSL
      hello-to-nixos,
      ...
    }:
    {
      nixosConfigurations."nixoshost" = nixpkgs.lib.nixosSystem {
        modules = [
          ./common.nix
          # And more your own modules
        ]
        ++ [ sops-nix.nixosModules.sops ]
        #
        # =============================
        # Required if you are using WSL
        # ++ [ nixos-wsl.nixosModules.default ]
        # =============================
        #
        # Hello-to-NixOS Modules
        #
        # See `flake.nix` at repository root
        # for detailed module definations
        ++ (with hello-to-nixos.nixosModules; [
          devspec.commonhw # systemd boot
          devspec.hw.wireless-adapter
          devspec.hw.thunderbolt
          devspec.hw.i2c
          devspec.hw.cpu.intel # Enable kvm-intel
          devspec.hw.cpu.amd # Enable kvm-amd
          devspec.hw.gpu.intel.enable # Enable i915
          devspec.hw.gpu.amd.enable # Enable amdgpu
          devspec.hw.gpu.nvidia.disable # Disable NVIDIA

          (devspec.luks {
            deviceLuksProvides = "luksDevice0";
            deviceLuksOn = "/dev/disk/by-uuid/<uuid>";
          })

          (common.os-builder "x86_64-linux") # OS building configurations
          devspec.locale # Locale
          devspec.watchdog # Watchdog
          # devspec.virtualisation# Virtualisation (QEMU)
          devspec.printer
          devspec.sound # pipeware
          # devspec.fprint # fprintd
          # devspec.battery # power save

          devspec.greet # greetd login
          devspec.terminal # kmscon and more
          # devspec.desk.common # Desktop common
          # devspec.desk.hyprland # Hyprland

          # Enable ONLY IF you are using WSL
          # (devspec.wsl "nixos")

          (common.users "nixos")
          common.basic-software # nvim, zsh, tmux, git and more

          common.optional.ssh
          # common.optional.developer # cargo and more
          # common.optional.browsers # browser applications
          # common.optional.documents # chafa and more
          # common.optional.proxy # proxy applications
          # common.optional.localsend # localsend
        ]);
      };
    };
}
