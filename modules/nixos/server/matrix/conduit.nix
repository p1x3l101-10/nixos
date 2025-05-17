{ globals, ... }:

{
  services.matrix-conduit = {
    enable = globals.server.dns.exists;
    settings.global = {
      address = "127.0.0.1"; 
      allow_registration = false;
      registration_token = "opensesame";
      database_backend = "rocksdb";
      port = 6167;
      server_name = "matrix.${globals.server.dns.basename}";
    };
  };
  environment.persistence."/nix/host/state/Servers/Matrix".directories = [
    { directory = "/var/lib/private/matrix-conduit"; mode = "0700"; }
  ];
  networking.sshForwarding.ports = [
    8448
  ];
}