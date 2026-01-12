{ ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      input = {
        method = "pipewire";
        source = "audo";
      };
    };
  };
}
