{ globals, ... }:

{
  imports = [
    ./coturn.nix
    ./element.nix
    ./livekit.nix
    ./synapse.nix

    ./appservices/discord-bridge.nix
  ];
  environment.persistence."${globals.dirs.state}/Servers/Matrix".directories = [
    { directory = "/var/lib/matrix-synapse"; user = "matrix-synapse"; group = "matrix-synapse"; }
    { directory = "/var/lib/matrix-appservice-discord"; user = "matrix-synapse"; group = "matrix-synapse"; }
  ];
}
