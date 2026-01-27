# NVIDIA GPU
{config, ...}: {
  hardware.nvidia = {
    modesetting.enable = true;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
