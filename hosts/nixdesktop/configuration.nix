# hosts/nixdesktop/configuration.nix
# Desktop-specific NixOS config: NVIDIA GPU, Intel CPU, dual-monitor setup
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../modules/stylix.nix
  ];

  networking.hostName = "nixdesktop";

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  system.stateVersion = "25.11";
}
