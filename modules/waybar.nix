{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];

        modules-center = [ "hyprland/window" ];

        modules-right = [
          "pulseaudio"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "warp-on-scroll" = false;
          "format" = "{name}: {windows}";
          "format-window-separator" = " ";
          "window-rewrite-default" = "ó°£†";
          "window-rewrite" = {
            "class<discord>" = "";
            "class<steam>" = "";
            "title<.*Godot.*>" = "<span size='large'></span>";
            "title</.*>" = "ó°Š ";
            "title<~.*>" = "ó°Š ";
            "title<neovim>" = "";
            "title<yazi>" = "";
            "class<com.mitchellh.ghostty>" = "ó°Š ";
            "class<firefox>" = "";
          };
        };

        "hyprland/submap" = {
          "format" = "âœŒï¸ {}";
          "max-length" = 8;
          "tooltip" = false;
        };

        "hyprland/window" = {
          "format" = "{}";
          "max-length" = 50;
          "separate-outputs" = true;
        };

        "pulseaudio" = {
          format = "ó°•¾ {volume}%";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "clock" = {
          format = "{:%a, %b %d %I:%M %p}";
          tooltip-format = "<big>{:%y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "tray" = {
          spacing = 10;
          icon-size = 20;
          show-passive-items = true;
        };
      };
    };
  };
}
