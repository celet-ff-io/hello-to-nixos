# User config
userName:
{ pkgs, ... }:
{
  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      ${userName} = {
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

      root = {
        shell = pkgs.zsh;
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.tmpfiles.rules = [
    "z /etc/nixos 2755 ${userName} wheel  - -"
    "Z /etc/nixos -    ${userName} wheel  - -"
  ];
}
