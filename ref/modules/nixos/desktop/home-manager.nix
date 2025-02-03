{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.pixel = import ./../../home/default;
  };

  systemd.services.home-manager-pixel-pre = {
    enable = true;
    before = [ "home-manager-pixel.service" ];
    script = "${pkgs.coreutils}/bin/chown -R pixel:users /home/pixel";
    wantedBy = [ "multi-user.target" "home-manager-pixel.service" ];
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
