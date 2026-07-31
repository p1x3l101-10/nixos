{ ... }:

{
  fileSystems."/nix/host/state/UserData/home/nova" = {
    device = "/nix/host/state/UserData/home/pixel";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/nix/host/state/UserData" ];
  };
}
