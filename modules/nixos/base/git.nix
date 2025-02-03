{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      init = {
        defaultBranch = "main";
      };
      url = {
        "git@github.com:" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
      url = {
        "git@gitlab.com:" = {
          insteadOf = [
            "gl:"
            "gitlab:"
          ];
        };
      };
    };
    lfs.enable = true;
  };
}
