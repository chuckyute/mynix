{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    inputs.hyprland.packages.${pkgs.system}.hypridle
    grim
    slurp
    swappy
    pamixer
    brightnessctl
    networkmanagerapplet
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # Monitor configuration
      monitor = [
        "HDMI-A-4, 1920x1080@60, 0x0, 1.0"
        "DP-4, 2560x1440@143.995, 1920x0, 1.0"
      ];

      # Environment variables (Hyprland-specific ones only)
      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 0;
        border_size = 2;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout
      dwindle = {
        preserve_split = true;
      };

      # Misc settings
      misc = {
        disable_hyprland_logo = true;
      };

      # Workspace rules - assign workspaces to monitors
      workspace = [
        "1, monitor:HDMI-A-4"
        "2, monitor:HDMI-A-4"
        "3, monitor:HDMI-A-4"
        "4, monitor:HDMI-A-4"
        "5, monitor:HDMI-A-4"
        "6, monitor:DP-4, default:true"
        "7, monitor:DP-4"
        "8, monitor:DP-4"
        "9, monitor:DP-4"
        "10, monitor:DP-4"
      ];

      # Window rules
      windowrulev2 = [
        # Float all windows by default
        "float, class:.*"

        # Override - tile specific applications
        "tile, class:(com.mitchellh.ghostty)"
        "tile, class:(firefox)"
        "tile, class:(discord)"

        # Application assignments
        "workspace 10, class:(steam)"
        "workspace 1, class:(firefox)"
        "workspace 2, class:(discord)"
      ];

      # Keybindings
      "$mod" = "SUPER";

      bind = [
        # Application launchers
        "$mod, t, exec, ghostty -e bash"
        "$mod, q, killactive"
        "$mod SHIFT, e, exec, wlogout"
        "$mod SHIFT, r, reload"

        # Window management
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, l, movewindow, r"

        # Layout
        "$mod, b, togglesplit"
        "$mod, v, togglesplit"
        "$mod, s, pseudo"
        "$mod, w, pseudo"
        "$mod, e, togglesplit"
        "$mod, f, fullscreen, 0"
        "$mod, o, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, space, togglefloating"
        "$mod, space, cyclenext"

        # Scratchpad (using special workspace)
        "$mod SHIFT, minus, movetoworkspace, special:scratchpad"
        "$mod, minus, togglespecialworkspace, scratchpad"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        "$mod, p, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mod SHIFT, p, exec, grim -g \"$(slurp)\" - | wl-copy"

        # Submaps for modes
        "$mod SHIFT, b, submap, brightness"
        "$mod SHIFT, v, submap, volume"
        "$mod, a, submap, applications"
        "$mod, r, submap, resize"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Submaps (modes)
      submap = [
        # Resize mode
        "resize"
        "binde = , h, resizeactive, -10 0"
        "binde = , j, resizeactive, 0 10"
        "binde = , k, resizeactive, 0 -10"
        "binde = , l, resizeactive, 10 0"
        "bind = , escape, submap, reset"
        "bind = , return, submap, reset"
        "submap = reset"

        # Applications mode
        "applications"
        "bind = , s, exec, steam"
        "bind = , s, submap, reset"
        "bind = , d, exec, discord"
        "bind = , d, submap, reset"
        "bind = , g, exec, godot"
        "bind = , g, submap, reset"
        "bind = , b, exec, firefox"
        "bind = , b, submap, reset"
        "bind = , escape, submap, reset"
        "bind = , return, submap, reset"
        "submap = reset"

        # Volume mode
        "volume"
        "binde = , k, exec, pamixer -i 5"
        "binde = , j, exec, pamixer -d 5"
        "bind = , space, exec, pamixer -t"
        "bind = , escape, submap, reset"
        "bind = , return, submap, reset"
        "submap = reset"

        # Brightness mode
        "brightness"
        "binde = , k, exec, brightnessctl set 5%+"
        "binde = , j, exec, brightnessctl set 5%-"
        "bind = , escape, submap, reset"
        "bind = , return, submap, reset"
        "submap = reset"
      ];

      # Startup applications
      exec-once = [
        "nm-applet --indicator"
        "waybar"
        "firefox"
        "discord"
        "sleep 3 && steam"
        "hypridle"
      ];
    };
  };

  # Hypridle configuration for power management
  services.hypridle = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hypridle;
    settings = {
      listener = [
        {
          timeout = 900; # 15 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Mako notifications
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };

  # Screenshot directory
  home.file = {
    ".config/swappy/config".text = ''
      [Default]
      save_dir = $HOME/pictures/screenshots
    '';
    "pictures/screenshots/.keep".text = "";
  };
}
