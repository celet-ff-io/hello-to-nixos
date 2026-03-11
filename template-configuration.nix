# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
  # pkgs,
  ...
}:
let
  # Set it to where this repository you cloned is
  hello-to-nixos = "/path/to/hello-to-nixos";
in
{
  imports = [
    (import "${hello-to-nixos}/modules/devspec/commonhw.nix") # systemd boot
    (import "${hello-to-nixos}/modules/devspec/hw/wireless-adapter.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/thunderbolt.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/i2c.nix")
    # (import "${hello-to-nixos}/modules/devspec/hw/cpu/intel.nix") # Enable kvm-intel
    # (import "${hello-to-nixos}/modules/devspec/hw/cpu/amd.nix") # Enable kvm-amd
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/intel") # Enable i915
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/amd") # Enable amdgpu
    # (import "${hello-to-nixos}/modules/devspec/hw/gpu/nvidia/disable.nix") # Disable NVIDIA
    # (import "${hello-to-nixos}/modules/devspec/luks.nix" {
    #   deviceLuksProvides = "luksDevice0";
    #   deviceLuksOn = "/dev/disk/by-uuid/<uuid>";
    # })

    (import "${hello-to-nixos}/modules/common/os-builder.nix" "x86_64-linux") # Experimental features and mirrors
    (import "${hello-to-nixos}/modules/devspec/locale.nix") # Locale
    (import "${hello-to-nixos}/modules/devspec/watchdog.nix") # Watchdog
    (import "${hello-to-nixos}/modules/devspec/printer.nix")
    (import "${hello-to-nixos}/modules/devspec/sound.nix") # pipeware
    # (import "${hello-to-nixos}/modules/devspec/fprint.nix") # fprintd
    # (import "${hello-to-nixos}/modules/devspec/battery.nix") # power save

    (import "${hello-to-nixos}/modules/devspec/greet.nix") # greetd login
    (import "${hello-to-nixos}/modules/devspec/terminal.nix") # kmscon and more
    # (import "${hello-to-nixos}/modules/devspec/desk/common.nix") # Desktop common
    # (import "${hello-to-nixos}/modules/devspec/desk/hyprland.nix") # Hyprland
    # (import "${hello-to-nixos}/modules/devspec/virtualisation.nix") # Virtualisation (QEMU)

    # Enable only if you are using WSL
    # Please make sure your nixos-wsl in nix-channel is updated to lastest version
    # or wsl.ssh-agent.enable may not exist and cause error
    # <nixos-wsl/modules>
    # (import "${hello-to-nixos}/modules/devspec/wsl.nix" "nixos")

    (import "${hello-to-nixos}/modules/common/users.nix" "nixos")
    (import "${hello-to-nixos}/modules/common/basic-software.nix") # nvim, zsh, tmux, git and more
    (import "${hello-to-nixos}/modules/common/optional/ssh.nix")
    # (import "${hello-to-nixos}/modules/common/optional/developer.nix") # cargo and more
    # (import "${hello-to-nixos}/modules/common/optional/browsers.nix") # browser applications
    # (import "${hello-to-nixos}/modules/common/optional/documents.nix") # chafa and more
    # (import "${hello-to-nixos}/modules/common/optional/proxy.nix") # proxy applications
    # (import "${hello-to-nixos}/modules/common/optional/localsend.nix") # LocalSend
  ];

  networking.hostName = "nixoshost"; # Define your hostname.

  # =============
  # Options

  shell = {
    autoStartTmux = true; # Auto start tmux
    # Before enable the following 'onLogin', do not forget to uncomment 'pkgs' in the function arguments!
    # onLogin = "${pkgs.coreutils}/bin/timeout 5s ${pkgs.cmatrix}/bin/cmatrix"; # Run once per login
  };
  # tuigreet.greeting = "> Hello to NixOS <"; # Customize with your own ASCII art!
  # terminal.font-size = 13;

  # Enable foot or kitty to run shell in Cage in Wayland
  # instead of kmscon
  # programs.foot.enable = true;
  # terminal.kitty.enable = true;

  # An option to not install Hyprexpo plugin for Hyprland
  # in case that Hyprexpo and Hyprland do not share the same version
  # however building of Hyprexpo usually requires the same version of Hyprland.
  # For installation only,
  # that simply enabling this won't make Hyprexpo work
  # unless you enable it in your `~/.config/hypr/hyprland.conf`.
  # programs.hyprland.plugins.hyprexpo.enable = false;

  # =============

  # Disk parts

  fileSystems."/" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@"
    ];
  };

  fileSystems."/nix" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@nix"
    ];
  };

  fileSystems."/home" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@home"
    ];
  };

  fileSystems."/boot" = {
    # device = "/dev/disk/by-uuid/<uuid>";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Swap
  swapDevices = [ ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
