{ config, lib, ... }:

lib.mkIf (config.networking.hostName == "pixels-pc") {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    loadModels = [
      "qwen2.5:32b" # 20 gigs, pretty dang large lol
    ];
  };
  environment.persistence."/nix/host/state/AI".directories = [
    { directory = "/var/lib/private/ollama"; mode = "0700"; }
  ];
}
