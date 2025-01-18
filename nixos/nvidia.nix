{ config, pkgs, lib, ... }:

{
  boot.blacklistedKernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
  };

  # if docker container are expected to run with nvidia gpu
  hardware.nvidia-container-toolkit = {
    enable = true;
  };
}
