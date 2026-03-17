{
  description = "Hello-to-NixOS template configuration";

  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    # Or from Githbu:
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Required if you are using WSL
    # nixos-wsl.url = "git+file:///path/to/nixos-wsl";
    # Or from Github:
    # nixos-wsl.url = "github:nix-community/NixOS-WSL";

    hello-to-nixos.url = "git+file:///path/to/hello-to-nixos";
    # Or from Github:
    # url = "github:celet-ff-io/hello-to-nixos";
  };

  outputs =
    {
      nixpkgs,
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
        #
        # =============================
        # Required if you are using WSL
        # ++ (with nixos-wsl.nixosModules; [ default ])
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
          # common.optional.browsers # cargo and more
          # common.optional.documents # browser applications
          # common.optional.proxy # chafa and more
          # common.optional.localsend # localsend
        ]);
      };
    };
}
