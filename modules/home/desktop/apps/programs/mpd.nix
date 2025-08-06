{ ... }:

{
  services = {
    mpd = {
      enable = true;
      network = {
        port = 6600;
        startWhenNeeded = true;
      };
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
}
