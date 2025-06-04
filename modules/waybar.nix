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
          "sway/workspaces"
          "sway/mode"
        ];

        modules-center = [ "sway/window" ];

        modules-right = [
          "pulseaudio"
          "clock"
          "custom/swayidle-status"
          "tray"
        ];

        "sway/workspaces" = {
          "disable-scroll" = true;
          "disable-markup" = false;
          "all-outputs" = false;
          "format" = "{name}|{windows}";
          "format-window-separator" = " ";
          "window-format" = "{icon}";
          "window-rewrite-default" = "󰣆";
          # use swaymsg -t get_tree to see all window info
          "window-rewrite" = {
            "class<discord>" = "";
            "class<steam>" = "";
            "title<.*Godot.*>" = "<span size='large'></span>";
            "title</.*>" = "󰊠";
            "title<~.*>" = "󰊠";
            "title<neovim>" = "";
            "title<yazi>" = "";
          };
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "clock" = {
          format = "{:%a, %b %d %I:%M %p}";
          tooltip-format = "<big>{:%y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "custom/swayidle-status" = {
          "format" = "Idle: {}";
          "exec" = "pgrep swayidle > /dev/null && echo ON || echo OFF";
          "interval" = 1;
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
