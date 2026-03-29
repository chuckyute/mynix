{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard hypridle grim slurp swappy
    pamixer brightnessctl networkmanagerapplet pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      input = { kb_layout = "us"; follow_mouse = 2; };

      general = {
        gaps_in = 2;
        gaps_out = 0;
        border_size = 2;
        no_focus_fallback = "true";
        resize_on_border = "true";
      };

      decoration = {
        rounding = 5;
        blur.enabled = false;
        shadow.enabled = false;
      };

      animations.enabled = false;
      dwindle.preserve_split = true;
      misc = { vfr = true; disable_hyprland_logo = true; };

      # v3 windowrule syntax (replaces deprecated windowrulev2)
      windowrule = [
        "match:class .*, float on"
        "match:class com.mitchellh.ghostty, tile on"
        "match:class firefox, tile on"
        "match:class discord, tile on"
        "match:title Steam, tile on"
        "match:class steam, workspace 10"
        "match:class firefox, workspace 1"
        "match:class discord, workspace 2"
      ];

      bind = [
        "SUPER, q, killactive"
        "SUPER SHIFT, e, exec, wlogout"
        "SUPER SHIFT, r, exec, hyprctl reload"

        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, l, movewindow, r"

        # togglesplit and pseudo moved behind layoutmsg in v0.54
        "SUPER, b, layoutmsg, togglesplit"
        "SUPER, v, layoutmsg, togglesplit"
        "SUPER, s, layoutmsg, pseudo"
        "SUPER, w, layoutmsg, pseudo"
        "SUPER, e, layoutmsg, togglesplit"
        "SUPER, f, fullscreen, 0"
        "SUPER, o, movecurrentworkspacetomonitor, +1"
        "SUPER SHIFT, space, togglefloating"
        "SUPER, space, cyclenext"

        "SUPER SHIFT, minus, movetoworkspace, special:scratchpad"
        "SUPER, minus, togglespecialworkspace, scratchpad"

        "SUPER, 1, workspace, 1"   "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER, 2, workspace, 2"   "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER, 3, workspace, 3"   "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER, 4, workspace, 4"   "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER, 5, workspace, 5"   "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER, 6, workspace, 6"   "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER, 7, workspace, 7"   "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER, 8, workspace, 8"   "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER, 9, workspace, 9"   "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER, 0, workspace, 10"  "SUPER SHIFT, 0, movetoworkspace, 10"

        "SUPER, p, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "SUPER SHIFT, p, exec, grim -g \"$(slurp)\" - | wl-copy"

        "SUPER SHIFT, b, submap, brightness"
        "SUPER SHIFT, v, submap, volume"
        "SUPER, a, submap, applications"
        "SUPER, r, submap, resize"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      submap = resize
      binde = , h, resizeactive, -10 0
      binde = , j, resizeactive, 0 10
      binde = , k, resizeactive, 0 -10
      binde = , l, resizeactive, 10 0
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset

      submap = volume
      binde = , k, exec, pamixer -i 5
      binde = , j, exec, pamixer -d 5
      bind = , space, exec, pamixer -t
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset

      submap = brightness
      binde = , k, exec, brightnessctl set 5%+
      binde = , j, exec, brightnessctl set 5%-
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset
    '';
  };

  services.hypridle = {
    enable = true;
    settings.listener = [{
      timeout = 900;
      on-timeout = "hyprctl dispatch dpms off";
      on-resume = "hyprctl dispatch dpms on";
    }];
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  home.file = {
    ".config/swappy/config".text = ''
      [Default]
      save_dir = $HOME/pictures/screenshots
    '';
    "pictures/screenshots/.keep".text = "";
  };
}
