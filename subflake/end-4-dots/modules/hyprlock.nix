{ config, lib, pkgs, ... }:
let
  enabled = config.illogical-impulse.enable;
  hyprlock-background = pkgs.writeShellScriptBin "hyprlock-background" ''
    #!${pkgs.bash}/bin/bash

    # Find current background image path
    image_path=$(swww query | awk -F 'image: ' '{print $2}')

    if [ -f "$image_path" ]; then
      rm -f /tmp/hyprlock-background.jpg
      ${pkgs.imagemagick}/bin/convert "$image_path" /tmp/hyprlock-background.jpg
    fi
    wait && hyprlock
  '';
in
{
  config = lib.mkIf enabled {
    home.packages = [
      hyprlock-background
    ];
    programs.hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            monitor = "";
            path = "/tmp/hyprlock-background.jpg";
            blur_passes = 0;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];

        general = {
          # no_fade_in = true;
          hide_cursor = true;
          grace = 0;
        };

        label = [
          {
            monitor = "";
            text = "cmd[update:1000] echo \"<span>$(date +\"%H\")</span>\"";
            color = "rgba(255, 255, 255, 1)";
            font_size = 250;
            font_family = "Alfa Slab One";
            position = "-80, 290";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo \"<span>$(date +\"%M\")</span>\"";
            color = "rgba(147, 196, 255, 1)";
            font_size = 250;
            font_family = "Alfa Slab One";
            position = "10, 70";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "cmd[update:1000] echo -e \"$(date +\"%B%d日 %A\" | sed 's/0/〇/g; s/1/一/g; s/2/二/g; s/3/三/g; s/4/四/g; s/5/五/g; s/6/六/g; s/7/七/g; s/8/八/g; s/9/九/g')\"";
            color = "rgba(255, 255, 255, 1)";
            font_size = 22;
            font_family = "Source Han Serif SC Bold";
            position = "0, -150";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "250, 60";
            outline_thickness = 0;
            outer_color = "rgba(21, 21, 21, 0.95)";
            dots_size = 0.1;
            dots_spacing = 1;
            dots_center = true;
            inner_color = "rgba(21, 21, 21, 0.95)";
            font_color = "rgba(200, 200, 200, 1)";
            fade_on_empty = false;
            placeholder_text = "<span face=\"Cascadia Code NF\" foreground=\"##8da3b9\"> $USER</span>";
            hide_input = false;
            position = "0, -290";
            halign = "center";
            valign = "center";
            zindex = 10;
          }
        ];
      };
    };
  };
}