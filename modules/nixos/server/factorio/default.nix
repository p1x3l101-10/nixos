{ pkgs, lib, userdata, ... }:

{
  services.factorio = {
    enable = true;
    package = (pkgs.factorio-headless.override {
      versionsJson = builtins.toFile "versions.json" (builtins.toJSON (import ./versions.nix { inherit lib; }));
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
  };
  environment.persistence."/nix/host/state/Servers/Factorio/Space-Age".directories = [
    "/var/lib/factorio"
  ];
  system.allowedUnfree.packages = [
    "factorio-headless"
  ];
}