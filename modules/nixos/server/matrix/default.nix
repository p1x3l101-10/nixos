{ ... }:

{
  imports = [
    ./coturn.nix
    ./element.nix
    ./livekit.nix
    ./synapse.nix

    ./appservices/discord-bridge.nix
  ];
}
