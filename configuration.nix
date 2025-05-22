{ pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/stylix.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      download-buffer-size = 256;
      # optimise sharing of identical files in store
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

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.wireless.userControlled.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    iwd
    iw
    wpa_supplicant
  ];

  services.displayManager.ly.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # opengl and gpu support
  hardware.graphics.enable = true;

  # audio
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # NOTE: only for vm
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
