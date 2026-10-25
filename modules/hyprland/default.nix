{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard hypridle grim slurp swappy
    pamixer brightnessctl networkmanagerapplet pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    # Hyprland 0.56+ only reads hyprland.lua; hyprlang (hyprland.conf) support is gone
    configType = "lua";

    settings = {
      env = [
        { _args = [ "WLR_NO_HARDWARE_CURSORS" "1" ]; }
        { _args = [ "NVD_BACKEND" "direct" ]; }
        { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "auto" ]; }
      ];

      config = {
        input = { kb_layout = "us"; follow_mouse = 2; };

        general = {
          gaps_in = 2;
          gaps_out = 0;
          border_size = 2;
          no_focus_fallback = true;
          resize_on_border = true;
        };

        decoration = {
          rounding = 5;
          blur.enabled = false;
          shadow.enabled = false;
        };

        animations.enabled = false;
        dwindle.preserve_split = true;
        misc = { disable_hyprland_logo = true; };
      };
    };

    extraConfig = ''
      hl.window_rule({ match = { class = ".*" }, float = true })
      hl.window_rule({ match = { class = "com.mitchellh.ghostty" }, tile = true })
      hl.window_rule({ match = { class = "firefox" }, tile = true })
      hl.window_rule({ match = { class = "discord" }, tile = true })
      hl.window_rule({ match = { title = "Steam" }, tile = true })
      hl.window_rule({ match = { class = "steam" }, workspace = "10" })
      hl.window_rule({ match = { class = "firefox" }, workspace = "1" })
      hl.window_rule({ match = { class = "discord" }, workspace = "2" })

      local exec = hl.dsp.exec_cmd

      hl.bind("SUPER + q", hl.dsp.window.close())
      hl.bind("SUPER + SHIFT + e", exec("wlogout"))
      hl.bind("SUPER + SHIFT + r", hl.dsp.reload_config())

      for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
      end

      hl.bind("SUPER + b", hl.dsp.layout("togglesplit"))
      hl.bind("SUPER + v", hl.dsp.layout("togglesplit"))
      hl.bind("SUPER + e", hl.dsp.layout("togglesplit"))
      hl.bind("SUPER + s", hl.dsp.window.pseudo())
      hl.bind("SUPER + w", hl.dsp.window.pseudo())
      hl.bind("SUPER + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      hl.bind("SUPER + o", hl.dsp.workspace.move({ monitor = "+1" }))
      hl.bind("SUPER + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + space", hl.dsp.window.cycle_next())

      hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))
      hl.bind("SUPER + minus", hl.dsp.workspace.toggle_special("scratchpad"))

      -- workspace 10 is on key 0
      for i = 1, 10 do
        local key = i % 10
        hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind("SUPER + p", exec("grim -g \"$(slurp)\" - | swappy -f -"))
      hl.bind("SUPER + SHIFT + p", exec("grim -g \"$(slurp)\" - | wl-copy"))

      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("SUPER + SHIFT + b", hl.dsp.submap("brightness"))
      hl.bind("SUPER + SHIFT + v", hl.dsp.submap("volume"))
      hl.bind("SUPER + a", hl.dsp.submap("applications"))
      hl.bind("SUPER + r", hl.dsp.submap("resize"))

      local function submapExitKeys()
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("return", hl.dsp.submap("reset"))
      end

      hl.define_submap("resize", function()
        hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
        hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
        hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
        hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
        submapExitKeys()
      end)

      hl.define_submap("volume", function()
        hl.bind("k", exec("pamixer -i 5"), { repeating = true })
        hl.bind("j", exec("pamixer -d 5"), { repeating = true })
        hl.bind("space", exec("pamixer -t"))
        submapExitKeys()
      end)

      hl.define_submap("brightness", function()
        hl.bind("k", exec("brightnessctl set 5%+"), { repeating = true })
        hl.bind("j", exec("brightnessctl set 5%-"), { repeating = true })
        submapExitKeys()
      end)
    '';
  };

  services.hypridle = {
    enable = true;
    settings.listener = [{
      timeout = 900;
      on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
      on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
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
