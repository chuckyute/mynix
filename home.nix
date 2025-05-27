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
    ./modules/yazi.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.code-new-roman
    github-cli
    firefox-wayland
    discord
    godot
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
