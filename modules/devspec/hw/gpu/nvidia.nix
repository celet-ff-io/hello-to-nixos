{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    types
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
    cudaCapabilities = lib.mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        List of CUDA capabilities to enable. See the NVIDIA documentation for a list of valid capabilities.
        Must be specified instead of null.
      '';
      example = [ "8.9" ];
    };
  };

  config =
    let
      cfg = config.htn3.device.hw.gpu.nvidia;
    in
    mkIf (with config.htn3; (enable && device.enable) && cfg.enable) {
      assertions = [
        {
          assertion = cfg.enable && (cfg.forceUnload || cfg.cudaCapabilities != null);
          message = "CUDA capabilities must be specified to avoid redundant builds.";
        }
      ];
      nixpkgs.config = mkIf (!cfg.forceUnload) {
        inherit (cfg) cudaCapabilities;
        cudaForwardCompat = mkDefault false;
        # We disable cudaSupport by default to avoid unnecessary rebuilds of packages
        # Use overrides to enable it for specific packages if needed
        cudaSupport = mkDefault false;
      };

      hardware.nvidia = mkIf (!cfg.forceUnload) {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      hardware.graphics.enable = true;

      services = lib.mkMerge [
        (mkIf (!cfg.forceUnload) {
          xserver.videoDrivers = [ "nvidia" ];
        })

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

      environment = mkIf (!cfg.forceUnload) {
        systemPackages = with pkgs; [
          nvitop
        ];
      };
    };
}
