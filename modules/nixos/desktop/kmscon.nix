{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    hwRender = true;
  };
}
