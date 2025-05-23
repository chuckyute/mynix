{ pkgs, ... }:

{
  home.username = "chuck";
  home.homeDirectory = "/home/chuck";
  home.stateVersion = "25.05"; # Please read the comment before changing.

  imports = [
    ./modules/ghostty.nix
    ./modules/nvim
    ./modules/sway.nix
    ./modules/waybar.nix
    ./modules/scripts.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.code-new-roman
    github-cli
    firefox-wayland
    xfce.thunar
    discord
  ];

  programs.git = {
    enable = true;
    userName = "chuckyute";
    userEmail = "charlieyoung0807@gmail.com";

    extraConfig = {
      "credential \"https://github.com\"" = {
        helper = "!/usr/bin/env gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
        helper = "!/usr/bin/env gh auth git-credential";
      };
      core.editor = "nvim";
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  stylix = {
    targets = {
      neovim.enable = false;
    };

    fonts = {
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
