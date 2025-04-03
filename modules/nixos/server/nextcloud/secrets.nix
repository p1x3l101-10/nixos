{ ... }:

{
  services.nextcloud.secretFile = "/run/secrets/nextcloud/secrets.json";
  systemd.tmpfiles.settings."11-preset-key"."/run/secrets/nextcloud/secrets.json".f = {
    user = "nextcloud";
    group = "nextcloud";
    mode = "0440";
    argument = "{}";
  };
}