{ lib, ... }:
{
  stylix.fonts.sizes = {
    applications = 22;
    desktop = 22;
    popups = 22;
  };

  programs.ghostty.settings.font-size = 19;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      { output = "eDP-2"; mode = "2560x1600@165"; position = "0x0"; scale = 1.0; }
      { output = ""; mode = "preferred"; position = "auto"; scale = 1; }
    ];

    workspace_rule =
      [ { workspace = "1"; monitor = "eDP-2"; default = true; } ]
      ++ map (ws: { workspace = toString ws; monitor = "eDP-2"; }) [ 2 3 4 5 6 7 8 9 10 ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("nm-applet --indicator")
      hl.exec_cmd("waybar")
      hl.exec_cmd("firefox")
      hl.exec_cmd("discord")
      hl.exec_cmd("sleep 3 && steam")
      hl.exec_cmd("hypridle")
    end)

    hl.bind("SUPER + t", hl.dsp.exec_cmd("ghostty -e bash"))
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })

    -- "reset": leave the submap after any bind fires
    hl.define_submap("applications", "reset", function()
      hl.bind("s", hl.dsp.exec_cmd("steam"))
      hl.bind("d", hl.dsp.exec_cmd("discord"))
      hl.bind("g", hl.dsp.exec_cmd("godot"))
      hl.bind("b", hl.dsp.exec_cmd("firefox"))
      hl.bind("escape", hl.dsp.submap("reset"))
      hl.bind("return", hl.dsp.submap("reset"))
    end)
  '';
}
