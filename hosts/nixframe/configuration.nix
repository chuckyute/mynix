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

  # MediaTek MT7925 WiFi drops out due to aggressive power saving
  networking.networkmanager.wifi.powersave = false;

  # amdgpu scatter-gather display causes GPU hangs under video decode (Discord streams, etc.)
  # mt7925e ASPM-related firmware timeouts cause IOMMU page faults that can hang the system
  boot.kernelParams = [ "amdgpu.sg_display=0" "mt7925e.disable_aspm=1" ];

  # NetworkManager's wpa_supplicant backend exposes no roam-aggressiveness controls, and
  # this mesh network's AP-to-AP steering (triggered by bandwidth spikes like Discord
  # streaming) races with the mt7925e driver and panics the kernel with a list_add
  # corruption BUG in mac80211. iwd lets us slow down roaming so the race isn't hit.
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = false;
      Network.RoamThreshold = "-70";
      Network.RoamThreshold5G = "-76";
      Network.RoamRetryInterval = "60";
    };
  };

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
