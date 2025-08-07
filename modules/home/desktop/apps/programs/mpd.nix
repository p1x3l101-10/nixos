{ pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      network = {
        listenAddress = "0.0.0.0";
        port = 6600;
        startWhenNeeded = true;
      };
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
        audio_output {
          type "fifo"
          name "my_fifo"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }
      '';
    };
    mpd-discord-rpc = {
      enable = true;
      settings = {
        hosts = [ "localhost:6600" ];
        format = {
          details = "$title";
          state = "On $album by $artist";
        };
      };
    };
    mpd-mpris = {
      enable = true;
      mpd.useLocal = true;
    };
  };
  home.packages = [
    pkgs.mpc
  ];
}
