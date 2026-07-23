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
          "battery"
        ];

        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "warp-on-scroll" = false;
          "format" = "{name}: <span size='large'>{windows}</span>";
          "format-window-separator" = " ";
          "window-rewrite-default" = "";
          "window-rewrite" = {
            "class<discord>" = "";
            "class<steam>" = "";
            "title<.*Godot.*>" = "";
            "title</.*>" = "󰊠";
            "title<~.*>" = "󰊠";
            "title<neovim>" = "";
            "title<yazi>" = "";
            "class<com.mitchellh.ghostty>" = "󰊠";
            "class<firefox>" = "";
          };
        };

        "hyprland/submap" = {
          "format" = "{}";
          "max-length" = 8;
          "tooltip" = false;
        };

        "hyprland/window" = {
          "format" = "{}";
          "max-length" = 50;
          "separate-outputs" = true;
        };

        "pulseaudio" = {
          format = "<span size='large'>{icon}</span> {volume}%";
          format-muted = "<span size='large'></span> {volume}%";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
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

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "<span size='large'>{icon}</span> {capacity}%";
          format-charging = "<span size='large'>󰂄</span> {capacity}%";
          format-plugged = "<span size='large'>󰚥</span> {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}, {power}W";
        };
      };
    };
  };
}
