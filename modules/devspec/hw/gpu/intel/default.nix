# Intel GPU
{pkgs, ...}: {
  boot.kernelModules = [
    "i915"
  ];
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];
}
