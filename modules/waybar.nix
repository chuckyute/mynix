{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "network"
          "pulseaudio"
          "clock"
          "tray"
        ];

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          # TODO: add little guy for disconnected
          format-disconnected = "Disconnected ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
          on-click-right = "pkill -f nm-connection-editor || true";
        };

        "wireplumber" = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "pavucontrol";
        };

        "clock" = {
          format = "{:%a, %b %d %H:%M}";
          tooltip-format = "<big>{:%y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "tray" = {
          spacing = 10;
        };
      };
    };
  };
}
