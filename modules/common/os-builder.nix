# OS building deps
hostPlatform:
{ lib, pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
    };
    optimise.automatic = true;
    gc.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    fuse
    fuse3
    jmtpfs
    sops
    age
    ssh-to-age
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  documentation.nixos.includeAllModules = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  nixpkgs.hostPlatform = lib.mkDefault hostPlatform;
}
