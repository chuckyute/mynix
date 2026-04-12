# hosts/nixframe/configuration.nix
# Framework 16 - AMD AI 9 HX 370 (iGPU: RDNA 3.5) + RX 7700S dGPU
{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../modules/stylix.nix
    inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series
  ];

  networking.hostName = "nixframe";

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    mesa
  ];

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.mesa
  ];

  hardware.amdgpu.overdrive.enable = true;

  services.fprintd.enable = true;

  environment.systemPackages = with pkgs; [
    corectrl
    lm_sensors
    radeontop
  ];

  programs.corectrl.enable = true;

  system.stateVersion = "25.05";
}
