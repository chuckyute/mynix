{ config, pkgs, ... }:

{
  home.username = "chuck";
  home.homeDirectory = "/home/chuck";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    ./modules/ghostty.nix
    ./modules/nvim
    ./modules/sway.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.code-new-roman
  ];

  programs.git = {
    enable = true;
    userName = "chuckyute";
    userEmail = "charlieyoung0807@gmail.com";
  };

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # opens ports in firewall for steam remote play
  #   dedicatedServer.openFirewall = true; # opens ports in firewall for source dedicated server
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
