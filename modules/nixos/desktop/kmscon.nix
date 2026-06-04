{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    hwRender = true;
  };
}
