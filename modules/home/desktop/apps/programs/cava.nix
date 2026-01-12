{ ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        bars = 0;
        bar_width = 1;
        bar_spacing = 0;
        sleep_timer = 30;
      };
      input = {
        method = "pipewire";
        source = "auto";
      };
      output = {
        method = "noncurses";
        orientation = "horizontal";
        horizontal_stereo = 1;
        channels = "stereo";
        disable_blanking = 1;
      };
      color = {
        gradient = 1;
        gradient_color_1 = "'#59cc33'";
        gradient_color_2 = "'#80cc33'";
        gradient_color_3 = "'#a6cc33'";
        gradient_color_4 = "'#cccc33'";
        gradient_color_5 = "'#cca633'";
        gradient_color_6 = "'#cc8033'";
        gradient_color_7 = "'#cc5933'";
        gradient_color_8 = "'#cc3333'";
        horizontal_gradient = 1;
        horizontal_gradient_color_1 = "'#c45161'";
        horizontal_gradient_color_2 = "'#e094a0'";
        horizontal_gradient_color_3 = "'#f2b6c0'";
        horizontal_gradient_color_4 = "'#f2dde1'";
        horizontal_gradient_color_5 = "'#cbc7d8'";
        horizontal_gradient_color_6 = "'#8db7d2'";
        horizontal_gradient_color_7 = "'#5e62a9'";
        horizontal_gradient_color_8 = "'#434279'";
      };
      smoothing = {
      };
    };
  };
}
