{ ... }:
{
  stylix.fonts.sizes = {
    applications = 16;
    desktop = 16;
    popups = 16;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-2, 2560x1600@165, 0x0, 1.6"
      ", preferred, auto, 1"
    ];

    workspace = [
      "1, monitor:eDP-1, default:true"
      "2, monitor:eDP-1"
      "3, monitor:eDP-1"
      "4, monitor:eDP-1"
      "5, monitor:eDP-1"
      "6, monitor:eDP-1"
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1"
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
