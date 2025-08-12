{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    hypridle
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

      # Animations (disabled for performance)
      animations = {
        enabled = false;
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
      bind = [
        # Application launchers
        "SUPER, t, exec, ghostty -e bash"
        "SUPER, q, killactive"
        "SUPER SHIFT, e, exec, wlogout"
        "SUPER SHIFT, r, exec, hyprctl reload"
        
        # Window management
        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, l, movewindow, r"
        
        # Layout
        "SUPER, b, togglesplit"
        "SUPER, v, togglesplit"
        "SUPER, s, pseudo"
        "SUPER, w, pseudo"
        "SUPER, e, togglesplit"
        "SUPER, f, fullscreen, 0"
        "SUPER, o, movecurrentworkspacetomonitor, +1"
        "SUPER SHIFT, space, togglefloating"
        "SUPER, space, cyclenext"
        
        # Scratchpad (using special workspace)
        "SUPER SHIFT, minus, movetoworkspace, special:scratchpad"
        "SUPER, minus, togglespecialworkspace, scratchpad"
        
        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
        
        # Screenshots
        "SUPER, p, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SUPER SHIFT, p, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # Submaps for modes
        "SUPER SHIFT, b, submap, brightness"
        "SUPER SHIFT, v, submap, volume"
        "SUPER, a, submap, applications"
        "SUPER, r, submap, resize"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
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

  # Define submaps outside of settings
  wayland.windowManager.hyprland.extraConfig = ''
    # Resize submap
    submap = resize
    binde = , h, resizeactive, -10 0
    binde = , j, resizeactive, 0 10
    binde = , k, resizeactive, 0 -10
    binde = , l, resizeactive, 10 0
    bind = , escape, submap, reset
    bind = , return, submap, reset
    submap = reset

    # Applications submap
    submap = applications
    bind = , s, exec, steam
    bind = , s, submap, reset
    bind = , d, exec, discord
    bind = , d, submap, reset
    bind = , g, exec, godot
    bind = , g, submap, reset
    bind = , b, exec, firefox
    bind = , b, submap, reset
    bind = , escape, submap, reset
    bind = , return, submap, reset
    submap = reset

    # Volume submap
    submap = volume
    binde = , k, exec, pamixer -i 5
    binde = , j, exec, pamixer -d 5
    bind = , space, exec, pamixer -t
    bind = , escape, submap, reset
    bind = , return, submap, reset
    submap = reset

    # Brightness submap
    submap = brightness
    binde = , k, exec, brightnessctl set 5%+
    binde = , j, exec, brightnessctl set 5%-
    bind = , escape, submap, reset
    bind = , return, submap, reset
    submap = reset
  '';
    };
  };

  # Hypridle configuration for power management
  services.hypridle = {
    enable = true;
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
    settings = {
      default-timeout = 5000;
    };
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
