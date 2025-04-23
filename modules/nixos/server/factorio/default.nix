{ pkgs, lib, userdata, ... }:

{
  services.factorio = {
    enable = false;
    package = (pkgs.factorio-headless.override {
      versionsJson = builtins.toFile "versions.json" (builtins.toJSON (import ./versions.nix));
    });
    requireUserVerification = false;
    nonBlockingSaving = true;
    openFirewall = true;
    game-password = "AdAstra";
    allowedPlayers = userdata [ "factorioUsername" ] [
      "scott"
    ];
    modList = { # Dlc server
      base = true;
      "elevated-rails" = true;
      quality = true;
      "space-age" = true;
    };
    port = 25565;
  };
  environment.persistence."/nix/host/state/Servers/Factorio/Space-Age".directories = [
    { directory = "/var/lib/private/factorio"; mode = "0700"; }
  ];
  system.allowedUnfree.packages = [
    "factorio-headless"
  ];
}