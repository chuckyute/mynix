{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi-wayland
    waybar
    mako
    wl-clipboard
    swayidle
    swaylock
    grim
    slurp
    wlr-which-key
    sov
  ];

  wayland.windowManager.sway = {
    enable = true;

    config =
      let
        modifier = "Mod4";
        mod = key: "${modifier}+${key}";
      in
      {
        inherit modifier;
        terminal = "ghostty";

        keybindings = {
          ${mod "Return"} = "exec ghostty";
          ${mod "q"} = "kill";
          ${mod "Shift+e"} = "exit";
          ${mod "1"} = "workspace number 1";
          ${mod "Shift+space"} = "floating toggle";
        };
      };
  };
}
