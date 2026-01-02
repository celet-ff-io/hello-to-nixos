# User config
userName: {pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "tss"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.tmpfiles.rules = [
    "d /etc/nixos 2755 ${userName} wheel - -"
    "Z /etc/nixos -    ${userName} wheel - -"
  ];
}
