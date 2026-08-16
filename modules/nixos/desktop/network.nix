{ pkgs, lib, ... }:

let
  f = lib.mkForce;
in {
  hardware.enableRedistributableFirmware = true;
  networking = {
    networkmanager = {
      enable = f true;
    };
    dhcpcd.enable = f true;
    useDHCP = f true;
    useNetworkd = f false;
  };
  services.resolved.enable = f false;
  systemd.network.enable = f false;
  environment.etc."NetworkManager/system-connections/.keep".source = (pkgs.runCommand "empty-file" {} "touch $out");
  systemd.mounts = (
    let
      mountUnit = what: where: {
        inherit what where;
        type = "none";
        options = "bind";
        wantedBy = [ "local-fs.target" ];
      };
      imperSubst = dir: (mountUnit "/nix/host/state/System/${dir}" dir);
    in [
      (imperSubst "/etc/NetworkManager/system-connections")
    ]
  );
  users.users.pixel.extraGroups = [ "networkmanager" ];
}
