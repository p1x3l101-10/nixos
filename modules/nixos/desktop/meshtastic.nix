{ pkgs, config, ... }:

{
  services.meshtasticd = {
    enable = false; # Waiting for upstream to fix the build
    port = 4403;
    settings = {};
  };

  # Local client
  environment.systemPackages =  with pkgs; [
    contact
    fetchtastic
  ];

  environment.persistence."/nix/host/state/Meshtastic" = {
    hideMounts = true;
    directories = [
      (with config.services.meshtasticd; {
        directory = dataDir;
        inherit user group;
      })
    ];
  };
}
