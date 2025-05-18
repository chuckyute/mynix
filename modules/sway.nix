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
    pamixer
    brightnessctl
    wlogout
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;

    config =
      let
        modifier = "Mod4";
        terminal = "ghostty";
        menu = "rofi -show drun";
        browser = "firefox";
        fileManager = "thunar";
        alt = "Mod1";
      in
      {
        inherit modifier terminal;

        gaps = {
          inner = 5;
          outer = 0;
          smartGaps = true;
          smartBorders = "on";
        };

        bars = [ { command = "waybar"; } ];

        window = {
          border = 2;
          hideEdgeBorders = "smart";
        };

        floating = {
          titlebar = true;
          boarder = 2;

          criteria = [
            { app_id = "^pavucontrol$"; }
            { app_id = "^nm-connection-editor$"; }
            { class = "^Lxappearance$"; }
            { app_id = "^blueberry.py$"; }
            { title = "^Picture-in-Picture$"; }
          ];
        };

        keybindings =
          let
            mod = key: "${modifier}+${key}";
            modAlt = key: "${modifier}+${alt}+${key}";
            modShift = key: "${modifier}+Shift+${key}";
          in
          {
            ${mod "t"} = "exec ghostty";
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
            ${modShift "k"} = "focus up";
            ${modShift "l"} = "focus right";
            # layout
            ${mod "b"} = "splith";
            ${mod "v"} = "splitv";
            ${mod "s"} = "layout stacking";
            ${mod "w"} = "layout tabbed";
            ${mod "e"} = "layout toggle split";
            ${mod "f"} = "fullscreen toggle";
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
            ${modShift "a"} = "mode applications";
            # print
            ${mod "p"} = "exec grim -g \"$(slurp)\" - | swappy -f -";
            ${modShift "p"} = "exec grim -g \"$(slurp)\" - | wl-copy";

            modes = {
              resize = {
                "h" = "resize shrink width 10px";
                "j" = "resize grow height 10px";
                "k" = "resize shrink height 10px";
                "l" = "resize grow width 10px";
                "Escape" = "mode default";
                "Return" = "mode default";
              };
              applications = {
                "s" = "exec steam; mode default";
                "d" = "exec discord; mode default";
                "f" = "exec firefox; mode default";
                "g" = "exec godot; mode default";
                "Escape" = "mode default";
                "Return" = "mode default";
              };
              volume = {
                "k" = "exec pamixer -i 5";
                "j" = "exec pamixer -d 5";
                "space" = "exec pamixer -t";
                "Escape" = "mode default";
                "Return" = "mode default";
              };
              brightness = {
                "k" = "exec brightnessctl set 5%+";
                "j" = "exec brightnessctl set 5%-";
                "Escape" = "mode default";
                "Return" = "mode default";
              };

            };

            startup = [
              { command = "mako"; }
              {
                command = "swayidle -w timeout 300 'swaylock -f' timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg\"output * dpms on\"' before-sleep 'swaylock -f'";
              }
            ];
          };
      };
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 5000;
    borderSize = 2;
    borderRadius = 5;
  };

  home.file = {
    ".config/swappy/config".text = ''
      [Default]
      save_dir = $HOME/pictures/screenshots
    '';
    "pictures/screenshots/.keep".text = "";
  };

}
