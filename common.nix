# common.nix
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
      download-buffer-size = 134217728;
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    timesyncd.enable = true;
    displayManager.ly.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    pipewire = {
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
    avahi = {
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
  };

  programs = {
    gamescope.enable = true;
    nm-applet.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    sudo = {
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
  };

  networking = {
    networkmanager = {
      enable = true;
      settings = {
        connection = {
          "ipv6.addr-gen-mode" = "stable-privacy";
          "ipv6.ip6-privacy" = "2";
        };
      };
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
      allowPing = true;
    };
  };
}
