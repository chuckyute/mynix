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
        height = 20;
        spacing = 6;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "pulseaudio"
          "clock"
          "tray"
        ];
        # Workspaces showing number + app icons
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          # Format: workspace number followed by application icons
          "format" = "{name} {icon}";
          "format-icons" = {
            # Default icons for different workspace states
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
          # Map application classes to icons
          # Use the most common/likely class names
          "window-rewrite" = {
            "class<firefox>" = "󰈹"; # Firefox (X11)
            "app_id<firefox>" = "󰈹"; # Firefox (Wayland)
            "class<discord>" = "󰙯"; # Discord
            "class<code>" = "󰨞"; # VS Code
            "app_id<ghostty>" = ""; # Ghostty (Wayland native)
            "class<Thunar>" = "󰝰"; # Thunar file manager
            "class<steam>" = "󰓓"; # Steam
            "class<Godot>" = "󰯂"; # Godot
            "class<pavucontrol>" = "󰕾"; # PulseAudio Volume Control
            "class<nm-connection-editor>" = "󰀂"; # NetworkManager
            # Terminal applications by title
            "title<.*nvim.*>" = ""; # Neovim in any terminal
            "title<.*vim.*>" = ""; # Vim in any terminal
          };
          # Show application names on hover
          "tooltip" = true;
          "tooltip-format" = "Workspace {name}\n{windows} window(s)";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "clock" = {
          format = "{:%a, %b %d %H:%M}";
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
