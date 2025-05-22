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
    swappy
    sov
    pamixer
    brightnessctl
    wlogout
    networkmanagerapplet
    pavucontrol
  ];

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];

    config =
      let
        modifier = "Mod4";
        terminal = "ghostty -e bash";
        browser = "firefox";
        left = "HDMI-A-4";
        right = "DP-4";
        # menu = "rofi -show drun";
        # fileManager = "thunar";
        # alt = "Mod1";
      in
      {
        inherit modifier terminal;
        bars = [ ];

        output = {
          ${left} = {
            mode = "1920x1080@60.000Hz";
            position = "0,0";
            scale = "0.75";
          };

          ${right} = {
            mode = "2560x1440@143.995Hz";
            position = "2560,0";
          };
        };

        gaps = {
          inner = 5;
          outer = 0;
          smartGaps = true;
          smartBorders = "on";
        };

        window = {
          border = 2;
          hideEdgeBorders = "smart";
          titlebar = false;
        };

        floating = {
          titlebar = true;
          border = 2;

          criteria = [
            { app_id = "^pavucontrol$"; }
            { class = "^pavucontrol$"; }
            { title = "^Volume Control$"; }
            { app_id = "^nm-connection-editor$"; }
            { class = "^Lxappearance$"; }
            { app_id = "^blueberry.py$"; }
            { title = "^Picture-in-Picture$"; }
          ];
        };

        keybindings =
          let
            mod = key: "${modifier}+${key}";
            #modAlt = key: "${modifier}+${alt}+${key}";
            modShift = key: "${modifier}+Shift+${key}";
          in
          {
            ${mod "t"} = "exec ${terminal}";
            ${mod "q"} = "kill";
            ${modShift "e"} = "exec wlogout";
            ${modShift "c"} = "exec swaylock";
            ${modShift "r"} = "reload";
            # window management
            ${mod "h"} = "focus left";
            ${mod "j"} = "focus down";
            ${mod "k"} = "focus up";
            ${mod "l"} = "focus right";
            ${modShift "h"} = "move left";
            ${modShift "j"} = "move down";
            ${modShift "k"} = "move up";
            ${modShift "l"} = "move right";
            # layout
            ${mod "b"} = "splith";
            ${mod "v"} = "splitv";
            ${mod "s"} = "layout stacking";
            ${mod "w"} = "layout tabbed";
            ${mod "e"} = "layout toggle split";
            ${mod "f"} = "fullscreen toggle";
            ${mod "o"} = "move workspace to output right";
            ${modShift "space"} = "floating toggle";
            ${mod "space"} = "focus mode_toggle";
            # scratchpad
            ${modShift "minus"} = "move scratchpad";
            ${mod "minus"} = "scratchpad show";
            # workspaces
            ${mod "1"} = "workspace number 1";
            ${mod "2"} = "workspace number 2";
            ${mod "3"} = "workspace number 3";
            ${mod "4"} = "workspace number 4";
            ${mod "5"} = "workspace number 5";
            ${mod "6"} = "workspace number 6";
            ${mod "7"} = "workspace number 7";
            ${mod "8"} = "workspace number 8";
            ${mod "9"} = "workspace number 9";
            ${mod "0"} = "workspace number 0";
            ${modShift "1"} = "move container to workspace number 1";
            ${modShift "2"} = "move container to workspace number 2";
            ${modShift "3"} = "move container to workspace number 3";
            ${modShift "4"} = "move container to workspace number 4";
            ${modShift "5"} = "move container to workspace number 5";
            ${modShift "6"} = "move container to workspace number 6";
            ${modShift "7"} = "move container to workspace number 7";
            ${modShift "8"} = "move container to workspace number 8";
            ${modShift "9"} = "move container to workspace number 9";
            ${modShift "0"} = "move container to workspace number 0";
            # modes
            ${modShift "b"} = "mode brightness";
            ${modShift "v"} = "mode volume";
            ${mod "a"} = "mode applications";
            ${mod "r"} = "mode resize";
            # print
            ${mod "p"} = "exec grim -g \"$(slurp)\" - | swappy -f -";
            ${modShift "p"} = "exec grim -g \"$(slurp)\" - | wl-copy";
            # NVIDIA settings exec nvidia-settings
          };

        modes = {
          resize = {
            "h" = "resize shrink width 10px # Shrink width";
            "j" = "resize grow height 10px # Grow height";
            "k" = "resize shrink height 10px # Shrink height";
            "l" = "resize grow width 10px # Grow width";
            "Escape" = "mode default";
            "Return" = "mode default";
          };

          applications = {
            "s" = "exec steam; mode default;";
            "d" = "exec discord; mode default;";
            "f" = "exec ${browser}; mode default;";
            "g" = "exec godot; mode default;";
            "Escape" = "mode default";
            "Return" = "mode default";
          };

          volume = {
            "k" = "exec pamixer -i 5 # Volume up";
            "j" = "exec pamixer -d 5 # Volume down";
            "space" = "exec pamixer -t # Mute";
            "Escape" = "mode default";
            "Return" = "mode default";
          };

          brightness = {
            "k" = "exec brightnessctl set 5%+ # Brightness up";
            "j" = "exec brightnessctl set 5%- # Brightness down";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };

        startup = [
          {
            command = ''
              swayidle -w \
              timeout 300 'swaylock -f -c 000000' \
              timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
              before-sleep 'swaylock -f -c 000000'
            '';
          }
          { command = "nm-applet --indicator"; }
        ];
      };
  };

  services.mako = {
    enable = true;

    settings = {
      defaultTimeout = 5000;
      borderSize = 2;
      borderRadius = 5;
    };
  };

  home.file = {
    ".config/swappy/config".text = ''
      [Default]
      save_dir = $HOME/pictures/screenshots
    '';
    "pictures/screenshots/.keep".text = "";
  };
}
