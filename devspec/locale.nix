# Locale config
{ config, lib, pkgs, ... }: {
  # Set your time zone.
  time.timeZone = lib.mkDefault "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  i18n.inputMethod = lib.mkIf config.hasDesktop {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };
}
