{ ... }:
{
  services.peerix = {
    enable = true;
    openFirewall = true;
    privateKeyFile = "/nix/host/keys/peerix/ed25519.key";
    publicKeyFile = "/nix/host/keys/peerix/ed25519.key.pub";
  };
  # List of computer pubkeys
  # Made with this command: `nix-store --generate-binary-cache-key pixels-server.local ./ed25519.key ./ed25519.key.pub`
  nix.settings.trusted-public-keys = [
    "pixels-server.local:IzcSB4a44p+j8z+HnrhK7dLZZRQJWQmtu6HuI7YgUqk="
  ];
}