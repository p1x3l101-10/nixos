{ ... }:
{
  services.kubo = {
    enable = true;
    startWhenNeeded = true;
    autoMount = true;
    enableGC = true;
    settings = {
      Datastore.StorageMax = "20GB";
    };
  };
  environment.persistence."/nix/host/state/IPFS".directories = [
    { directory = "/var/lib/ipfs"; user = "ipfs"; group = "ipfs"; }
  ];
}