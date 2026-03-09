# User config
userName:
{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userName} = {
    isNormalUser = true;
    linger = true;
    extraGroups = [ "wheel" "tss" "networkmanager" "git" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };

  users.groups.git = { };

  security.sudo.wheelNeedsPassword = false;

  systemd.tmpfiles.rules = [
    "z /etc/nixos 2755 ${userName} wheel  - -"
    "Z /etc/nixos -    ${userName} wheel  - -"
    "z /srv/git   2775 ${userName} git    - -"
    "Z /srv/git   -    ${userName} git    - -"
  ];
}
