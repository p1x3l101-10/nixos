{ lib, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings =
      let
        font = "Monospace";
      in
      {
        general.hide_cursor = false;
        auth = {
          fingerprint.enabled = false;
        };
        animations = {
          enabled = true;
          bezier = "linear, 1, 1, 0, 0";
          animation = [
            "fadeIn, 1, 5, linear"
            "fadeOut, 1, 5, linear"
            "inputFieldDots, 1, 2, linear"
          ];
        };
        background = {
          monitor = "";
          path = lib.mkForce "screenshot";
          blur_passes = 3;
        };
        input-field = {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_thickness = "rgba(0, 0, 0, 0)";

          fade_on_empty = false;
          rounding = 15;

          font_family = font;
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";

          dots_text_format = "*";
          dots_size = 0.4;
          dots_spacing = 0.3;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };
        label = [
          # TIME
          {
            monitor = "";
            text = "$TIME12";
            font_size = "90";
            font_family = font;
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          # DATE
          {
            monitor = "";
            text = "cmd[update:60000] date +\"%A, %d %B %Y\"";
            font_size = "25";
            font_family = font;
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];
      };
  };
}
