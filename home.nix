{ pkgs, ... }:
{
  home.username = "chuck";
  home.homeDirectory = "/home/chuck";
  home.stateVersion = "25.05";

  imports = [
    ./modules/ghostty.nix
    ./modules/nvim
    ./modules/hyprland/default.nix
    ./modules/waybar.nix
    ./modules/scripts.nix
    ./modules/yazi.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.code-new-roman
    github-cli
    discord
    godot
    vlc
    unzip
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "chuckyute";
      user.email = "charlieyoung0807@gmail.com";
      "credential \"https://github.com\"".helper = "!/usr/bin/env gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!/usr/bin/env gh auth git-credential";
      core.editor = "nvim";
    };
  };

  gtk.gtk4.theme = null;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    LIBGL_ALWAYS_INDIRECT = "0";
    GDK_SCALE = "1.2";
    QT_SCALE_FACTOR = "1.2";
  };

  programs.home-manager.enable = true;
}
