# nixos-common.nix
# Shared NixOS configuration for all hosts.
# Host-specific files (GPU, hostname, hardware) live in hosts/<name>/configuration.nix
{ pkgs, inputs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      download-buffer-size = 4096;
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
      persistent = true;
      randomizedDelaySec = "45min";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [ "ALL" ];
      }
    ];
    extraConfig = ''
      Defaults timestamp_timeout=60
    '';
  };

  # Wireless managed by NetworkManager; wpa_supplicant disabled
  networking.wireless.enable = false;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    settings = {
      connection = {
        "ipv6.addr-gen-mode" = "stable-privacy";
        "ipv6.ip6-privacy" = "2";
      };
    };
  };

  programs.nm-applet.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ ];
    allowedTCPPorts = [ ];
    allowPing = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.timesyncd.enable = true;
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.chuck = {
    isNormalUser = true;
    description = "Charles";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    iw
    wget
    curl
    firefox
  ];

  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.quantum" = 256;
      };
    };
  };

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.gamescope.enable = true;

  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
}
