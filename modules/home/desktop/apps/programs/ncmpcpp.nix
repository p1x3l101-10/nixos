{ pkgs, ... }:

{
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      visualizerSupport = true;
    };
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer feed";
      visualizer_in_stereo = true;
      visualizer_type = "spectrum";
      visualizer_look = "+|";
    };
  };
}
