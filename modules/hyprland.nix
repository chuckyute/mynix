{config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    # inputs.hyprland.packages.${pkgs.system}.hyprland-protocols
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      monitor = ",preferred,auto,=";
      bind = [
        "SUPER, RETURN, exec, ghostty"
        "SUPER, Q, killactive"
        "SUPER, M, exit"
      ];

      animations.enable = false;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };
    };
  };

  xdg.configFile = {
    "uwsm/sessions/hyprland.conf".text = ''
      exec = "Hyprland"
      environment = [
      "XDG_CURRENT_DESKTOP=Hyprland"
      "XDG_SESSION_TYPE=wayland"
      "XCURSOR_SIZE=24"
      ]
    '';

    "uwsm/wayland-sessions/hyprland.desktop".text = ''
      [Desktop Entry]
      Name=Hyprland
      Comment=Hyprland Wayland compositor
      Exec=uwsm start hyprland
      Type=Application
    '';
  };

}
