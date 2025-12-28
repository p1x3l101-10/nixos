{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "scott.blatt.0b10@gmail.com";
        name = "Pixel";
      };
    };
  };
}
