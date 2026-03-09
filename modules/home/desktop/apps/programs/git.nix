{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        email = "scott.blatt.0b10@gmail.com";
        name = "Pixel";
        signingkey = "ACD0910C3FD1322FCE8F73A63C2D22F9DE687571";
      };
      commit.gpgsign = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };
}
