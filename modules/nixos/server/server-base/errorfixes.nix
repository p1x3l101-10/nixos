{ config, lib, ... }:

let
  sys-persist = config.environment.persistence."/nix/host/state/System".directories;
in {
  environment.persistence."/nix/host/state/System".directories = lib.lists.remove "/etc/NetworkManager/system-connections" sys-persist;
}