# battery configs
{
  lib,
  pkgs,
  ...
}: {
  boot.kernelParams = [
    "pcie_aspm.policy=powersave"
    "i915.enable_fbc=1"
    "i915.enable_guc=3"
    "i915.enable_dc=2"
    "i915.enable_psr=1"
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 50;

      SATA_ALPM_ENABLE_ON_AC = "max_performance";
      SATA_ALPM_ENABLE_ON_BAT = "min_power";

      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 95;

      NMI_WATCHDOG = 0;
    };
  };

  powerManagement.powertop.enable = true;

  programs.tmux = {
    plugins = with pkgs.tmuxPlugins; [
      battery
    ];
    extraConfig = lib.mkAfter ''
      set -g @batt_remain_short 'true'
      set -g @batt_icon_status_unknown '󱤁'
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    '';
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];

  tmux.status.battery = "#{battery_color_bg} #{battery_icon} #{battery_percentage} 󱧥 #{battery_remain}";
}
