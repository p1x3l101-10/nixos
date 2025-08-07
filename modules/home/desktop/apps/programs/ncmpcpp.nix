{ pkgs, config, ... }:

{
  home.packages = [
    (pkgs.ncmpcpp.override {
      visualizerSupport = true;
    })
  ];
  xdg.configFile."ncmpcpp/config".text = ''
    visualizer_data_source = "/tmp/mpd.fifo"
    visualizer_output_name = "Visualizer feed"
    visualizer_in_stereo = "yes"
    visualizer_type = "spectrum"
    visualizer_look = "+|"
    mpd_music_dir = "${config.services.mpd.musicDirectory}"
  '';
}
