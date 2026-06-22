{ ... }: {
  imports = [
    ./common.nix
    ./i2c.nix
    ./thunderbolt.nix
    ./wireless-adapter.nix

    ./cpu
    ./gpu
  ];
}
