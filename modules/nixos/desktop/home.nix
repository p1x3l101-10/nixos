{ pkgs, inputs, ext, lib, ... }:

{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];
  users.users.pixel = {
    isNormalUser = true;
    initialHashedPassword = "$6$oV5Ug.0o/PznQ3IX$D7.E83RZxPJ35MfLKdTgXxCWXi/Wyl3WFfOpzQinlL46puf8bgzbpL0usTFnOhyeUvHcrV30nnCGKprPFsuGM1";
    extraGroups = [
      "wheel"
      "ipfs"
      "kvm"
      "tablet"
      "adbusers"
    ];
    uid = 1000;
  };
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1000".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
  nix.settings.trusted-users = [ "@wheel" ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs ext;
    };
    users.pixel = { osConfig, lib, ... }: (
      lib.internal.lists.switch [
        {
          case = (osConfig.networking.hostName == "pixels-pc");
          out = {
            imports = with inputs.self.homeModules; [
              desktop
              vr
            ];
          };
        }
      ]
        {
          imports = with inputs.self.homeModules; [
            desktop
          ];
        }
    );
  };
  nixpkgs.config = {
    permittedInsecurePackages = [
      "libxml2-2.13.8" # Already updated, but apparantly the CVE list has not yet
      "qtwebengine-5.15.19" # Stremio needs qtwebengine, and the old workaround no longer works
    ];
  };
  networking.firewall = lib.fix (self: {
    allowedTCPPorts = [
      6600
      8080
    ];
    allowedUDPPorts = self.allowedTCPPorts;
  });
  # Desktop portals
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
  # Suboptimal, but fixes application menus
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.garcon}/etc/xdg/menus/xfce-applications.menu";
}
