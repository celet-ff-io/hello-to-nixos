{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (with config.htn3; (enable && device.enable)) {
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;
    kernelParams = [ "iommu=pt" ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 7;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    tmp.cleanOnBoot = true;
  };

  networking.nftables.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  systemd = {
    user.services.mpris-proxy = {
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = "60s";
      };
    };

    # System watchdog
    settings.Manager = {
      RebootWatchdogSec = "10min";
      RuntimeWatchdogSec = "30s";
    };
  };
}
