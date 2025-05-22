{ pkgs, ... }:

{
  home.packages = [ pkgs.ghostty ];

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      font-family = "CodeNewRoman Nerd Font";
      font-size = 19;
    };
  };
}
