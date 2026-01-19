{ config, ... }:

{
  users.users.pixel.shell = config.home-manager.users.pixel.programs.nushell.package;
}
