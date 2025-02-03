{ config, ... }:
{
  sops.secrets.pixel-password = {
    neededForUsers = true;
    sopsFile = ./data/passwords.yaml;
  };
  users.users.pixel.hashedPasswordFile = config.sops.secrets.pixel-password.path;
}
