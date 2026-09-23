{ ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      term = "kitty";
      location = "center";
      insensitive = true;
      prompt = "Search";
    };
  };
}
