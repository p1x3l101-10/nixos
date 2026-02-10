{ lib, ... }:

{
  clientConfig = {
    "m.homeserver".base_url = baseUrl;
    "m.identity_server".base_url = "https://vector.im";
    "org.matrix.msc3575.proxy".url = baseUrl;
    "org.matrix.msc4143.rtc_foci" = [
      {
        type = "livekit";
        livekit_service_url = "${baseUrl}/livekit/jwt";
      }
    ];
  };
  serverConfig = {
    "m.server" = "${fqdn}:443";
  };
}
