# Network proxy
{pkgs, ...}: {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  systemd.tmpfiles.rules = [
    "d /root/.config/mihomo 2775 root wheel - -"
    "Z /root/.config/mihomo -    root wheel - -"
  ];
  services.mihomo = {
    enable = true;
    configFile = "/root/.config/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    clashtui
  ];
}
