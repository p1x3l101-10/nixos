{ ... }:

let
  inherit ((import ../s3/key.nix).nextcloud) key; 
in {
  services.nextcloud.config.objectstore.s3 = {
    enable = true;
    bucket = "nextcloud";
    autocreate = true;
    inherit key;
    secretFile = "/run/secrets/s3/nextcloud.psk";
    hostname = "10.10.10.3";
    useSsl = false;
    port = 9000;
    usePathStyle = true;
    region = "us-east-1";
    # Go back and read this:
    # https://nixos.wiki/wiki/Nextcloud#Object_store
  };
}