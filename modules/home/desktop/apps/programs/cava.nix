{ ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      input = {
        method = "pipewire";
        source = "auto";
      };
      output = {
        method = "noncurses";
        orientation = "horizontal";
        channels = "stereo";
        disable_blanking = 1;
      };
      color = {
        gradient = 1;
        horizontal_gradient = 1;
      };
    };
  };
}
