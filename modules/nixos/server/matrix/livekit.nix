{ config, lib, pkgs, globals, ... }: 

let
  inherit (globals.server.dns) exists basename;
  inherit (lib.internal.webserver) mkWellKnown;
  keyFile = "${globals.dirs.keys}/Livekit/Livekit.key";
  dns = "matrix.${basename}";
in {
  services.livekit = {
    enable = exists;
    openFirewall = true;
    settings.room.auto_create = false;
    inherit keyFile;
  };
  services.lk-jwt-service = {
    enable = exists;
    # can be on the same virtualHost as synapse
    livekitUrl = "wss://${dns}/livekit/sfu";
    port = 8787;
    inherit keyFile;
  };
  # generate the key when needed
  systemd.services.livekit-key = {
    before = [ "lk-jwt-service.service" "livekit.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ livekit coreutils gawk ];
    script = ''
        echo "Key missing, generating key"
        mkdir -p "$(dirname '${keyFile}')"
        echo "lk-jwt-service: $(livekit-server generate-keys | tail -1/nix/store/0sqr1dw9n4wisrvra6lgfwwkjmvkxgiw-lk-jwt-service-0.4.1/bin/lk-jwt-service | awk '{print $3}')" > "${keyFile}"
    '';
    serviceConfig.Type = "oneshot";
    unitConfig.ConditionPathExists = "!${keyFile}";
  };
  # restrict access to livekit room creation to a homeserver
  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "${dns}";
  services.nginx.virtualHosts."${dns}".locations = {
    "^~ /livekit/jwt/" = {
      priority = 400;
      proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
    };
    "^~ /livekit/sfu/" = {
      extraConfig = ''
        proxy_send_timeout 120;
        proxy_read_timeout 120;
        proxy_buffering off;

        proxy_set_header Accept-Encoding gzip;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
      priority = 400;
      proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
      proxyWebsockets = true;
    };
  };
}
