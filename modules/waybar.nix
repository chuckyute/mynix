{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    # Hyprland 0.56 evaluates `hyprctl dispatch` as Lua, but waybar 0.15 still sends
    # legacy `dispatch workspace N`, which broke clicking workspaces in the bar.
    package = pkgs.waybar.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (pkgs.writeText "waybar-hyprland-lua-dispatch.patch" ''
          --- a/src/modules/hyprland/workspace.cpp
          +++ b/src/modules/hyprland/workspace.cpp
          @@ -71,20 +71,20 @@
               try {
                 if (id() > 0) {  // normal
                   if (m_workspaceManager.moveToMonitor()) {
          -          m_ipc.getSocket1Reply("dispatch focusworkspaceoncurrentmonitor " + std::to_string(id()));
          +          m_ipc.getSocket1Reply("dispatch hl.dsp.focus({ workspace = " + std::to_string(id()) + ", on_current_monitor = true })");
                   } else {
          -          m_ipc.getSocket1Reply("dispatch workspace " + std::to_string(id()));
          +          m_ipc.getSocket1Reply("dispatch hl.dsp.focus({ workspace = " + std::to_string(id()) + " })");
                   }
                 } else if (!isSpecial()) {  // named (this includes persistent)
                   if (m_workspaceManager.moveToMonitor()) {
          -          m_ipc.getSocket1Reply("dispatch focusworkspaceoncurrentmonitor name:" + name());
          +          m_ipc.getSocket1Reply("dispatch hl.dsp.focus({ workspace = \"name:" + name() + "\", on_current_monitor = true })");
                   } else {
          -          m_ipc.getSocket1Reply("dispatch workspace name:" + name());
          +          m_ipc.getSocket1Reply("dispatch hl.dsp.focus({ workspace = \"name:" + name() + "\" })");
                   }
                 } else if (id() != -99) {  // named special
          -        m_ipc.getSocket1Reply("dispatch togglespecialworkspace " + name());
          +        m_ipc.getSocket1Reply("dispatch hl.dsp.workspace.toggle_special(\"" + name() + "\")");
                 } else {  // special
          -        m_ipc.getSocket1Reply("dispatch togglespecialworkspace");
          +        m_ipc.getSocket1Reply("dispatch hl.dsp.workspace.toggle_special()");
                 }
                 return true;
               } catch (const std::exception& e) {
        '')
      ];
    });
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];

        modules-center = [ "hyprland/window" ];

        modules-right = [
          "pulseaudio"
          "clock"
          "tray"
          "battery"
        ];

        "hyprland/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "warp-on-scroll" = false;
          "format" = "{name}: <span size='large'>{windows}</span>";
          "format-window-separator" = " ";
          "window-rewrite-default" = "";
          "window-rewrite" = {
            "class<discord>" = "";
            "class<steam>" = "";
            "title<.*Godot.*>" = "";
            "title</.*>" = "󰊠";
            "title<~.*>" = "󰊠";
            "title<neovim>" = "";
            "title<yazi>" = "";
            "class<com.mitchellh.ghostty>" = "󰊠";
            "class<firefox>" = "";
          };
        };

        "hyprland/submap" = {
          "format" = "{}";
          "max-length" = 8;
          "tooltip" = false;
        };

        "hyprland/window" = {
          "format" = "{}";
          "max-length" = 50;
          "separate-outputs" = true;
        };

        "pulseaudio" = {
          format = "<span size='large'>{icon}</span> {volume}%";
          format-muted = "<span size='large'></span> {volume}%";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        "clock" = {
          format = "{:%a, %b %d %I:%M %p}";
          tooltip-format = "<big>{:%y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "tray" = {
          spacing = 10;
          icon-size = 20;
          show-passive-items = true;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}, {power}W";
        };
      };
    };
  };
}
