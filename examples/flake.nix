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
          "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
          ./common.nix
          # And more your own modules
        ]
        ++ [ sops-nix.nixosModules.sops ]
        #
        # =============================
        # Required if you are using WSL
        # ++ [ nixos-wsl.nixosModules.wsl ]
        # =============================
        #
        # Hello-to-NixOS Modules
        #
        # See `flake.nix` at repository root
        # for detailed module definations
        ++ (with hello-to-nixos.nixosModules; [
          default
          # # Or separately
          # common
          # devspec

          # # Or if you are using WSL (no `devspec` then)
          # common
          # wsl
        ]);
      };
    };
}
