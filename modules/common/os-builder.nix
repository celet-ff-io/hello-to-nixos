# OS building deps
hostPlatform:
{ lib, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = lib.mkForce [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [ fuse fuse3 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  nixpkgs.hostPlatform = lib.mkDefault hostPlatform;
}
