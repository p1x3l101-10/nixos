{ ... }:

{
  homebrew.brews = [{
    name = "ssh-proxy";
    restart_service = true;
  }];
}