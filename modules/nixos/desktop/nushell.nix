{ config, ... }:

let
  nushellPkg = config.home-manager.users.pixel.programs.nushell.package;
in {
  users.users.pixel.shell = nushellPkg;
  environment.shells = [ nushellPkg ];
}
