{ config, ... }:
{
  sops.secrets.pixel-ssh-key = {
    sopsFile = ./data/keys.yaml;
    owner = config.users.users.pixel.name;
    group = config.users.users.pixel.group;
    mode = "0400";
    path = "/nix/host/state/${config.users.users.pixel.home}/.ssh/id_rsa";
  };
  sops.secrets.root-ssh-key = {
    sopsFile = ./data/keys.yaml;
    owner = config.users.users.root.name;
    group = config.users.users.root.group;
    mode = "0400";
    path = "${config.users.users.root.home}/.ssh/id_rsa";
  };
}
