{ ... }:
{
  stylix.fonts.sizes = {
    applications = 14;
    desktop = 14;
    popups = 14;
  };

  programs.ghostty.settings.font-size = 8;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-2, 2560x1600@165, 0x0, 2.0"
      ", preferred, auto, 1"
    ];

    workspace = [
      "1, monitor:eDP-2, default:true"
      "2, monitor:eDP-2"
      "3, monitor:eDP-2"
      "4, monitor:eDP-2"
      "5, monitor:eDP-2"
      "6, monitor:eDP-2"
      "7, monitor:eDP-2"
      "8, monitor:eDP-2"
      "9, monitor:eDP-2"
      "10, monitor:eDP-2"
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
