{ config, lib, ... }:

{
  # Convert ranges into ports
  networking.sshForwarding.ports = (lib.lists.flatten
    (map
      ({ host, remote }: let
        range = host.end - host.start;
      in map
        (x:
          {
            host = x + host.start;
            remote = x + remote.start;
          }
        )
        (builtins.genList (x: x + 1) range)
      )
      config.networking.sshForwarding.portRanges
    )
  );
}
