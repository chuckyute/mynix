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
      { output = "HDMI-A-4"; mode = "1920x1080@99.65"; position = "0x0"; scale = 0.8; }
      { output = "DP-4"; mode = "2560x1440@144"; position = "auto-right"; scale = 1.0; }
    ];

    workspace_rule =
      map (ws: { workspace = toString ws; monitor = "HDMI-A-4"; }) [ 1 2 3 4 5 ]
      ++ [ { workspace = "6"; monitor = "DP-4"; default = true; } ]
      ++ map (ws: { workspace = toString ws; monitor = "DP-4"; }) [ 7 8 9 10 ];
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
