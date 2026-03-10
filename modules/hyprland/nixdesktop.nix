{ ... }:
{
  stylix.fonts.sizes = {
    applications = 18;
    desktop = 18;
    popups = 18;
  };

  home.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-4, 1920x1080@99.65, 0x0, 0.8"
      "DP-4, 2560x1440@144, auto-right, 1.0"
    ];

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

    exec-once = [
      "nm-applet --indicator"
      "waybar"
      "firefox"
      "discord"
      "sleep 3 && steam"
      "hypridle"
    ];

    bind = [
      "SUPER, t, exec, ghostty -e bash"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
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
  '';
}
