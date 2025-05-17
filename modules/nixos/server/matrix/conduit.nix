{ globals, ... }:

{
  services.matrix-conduit = {
    enable = globals.server.dns.exists;
    settings.global = {
      address = "127.0.0.1"; 
      # Change this to `false` after the first user (admin) is registered,
      # and then run `$ nixos-rebuild switch`.
      allow_registration = true;
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