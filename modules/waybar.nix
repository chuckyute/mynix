{ pkgs, lib, ... }:
{

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 6;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "pulseaudio"
          "clock"
          "tray"
        ];
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          "format" = "{name}: {windows}";
          "format-window-seperator" = " ";
          "window-format" = "{icon}";
          "window-rewrite-default" = "";
          "window-rewrite" =
            let
              mkAppRules =
                name: icon:
                let
                  lower = lib.strings.toLower name;
                  capital = lib.strings.concatStrings [
                    (lib.strings.toUpper (lib.strings.substring 0 1 lower))
                    (lib.strings.substring 1 (-1) lower)
                  ];
                in
                {
                  "class<${lower}>" = icon;
                  "class<${capital}>" = icon;
                  "app_id<${lower}>" = icon;
                  "app_id<${capital}>" = icon;
                };

              mkTitleRules =
                patterns: icon:
                lib.listToAttrs (
                  map (pattern: {
                    name = "title<${pattern}>";
                    value = icon;
                  }) patterns
                );
            in
            lib.foldl' (acc: rules: acc // rules) { } [
              (mkAppRules "firefox" "")
              (mkTitleRules [ ".*nvim.*" ".*vim.*" ] "")
            ];
          # Format: workspace number followed by application indicators
        };
        "pulseaudio" = {
          format = "{volume}% {icon}";
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
      };
    };
  };
}
