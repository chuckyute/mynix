{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      font-family = "CodeNewRoman Nerd Font Mono";
      font-size = 16;
    };
  };
}
