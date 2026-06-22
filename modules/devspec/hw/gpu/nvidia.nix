{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.htn3.device.hw.gpu.nvidia = {
    enable = mkEnableOption ''
      Set this to true to enable features specific to Nvidia GPUs.
    '';
    forceUnload = mkEnableOption ''
      Set this to true to force not using Nvidia GPU.
    '';
  };

  config =
    let
      cfg = config.htn3.device.hw.gpu.nvidia;
    in
    mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      hardware.graphics.enable = true;

      services = lib.mkMerge [
        {
          xserver.videoDrivers = [ "nvidia" ];
        }

        (mkIf cfg.forceUnload {
          udev.extraRules = ''
            # Remove NVIDIA USB xHCI Host Controller devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA USB Type-C UCSI devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA Audio devices, if present
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

            # Remove NVIDIA VGA/3D controller devices
            ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
          '';

        })
      ];

      boot = mkIf cfg.forceUnload {
        blacklistedKernelModules = [
          "nouveau"
          "nvidia"
        ];
      };

      environment.systemPackages = with pkgs; [
        nvitop
      ];
    };
}
