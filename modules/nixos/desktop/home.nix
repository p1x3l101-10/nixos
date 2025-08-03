{ pkgs, inputs, ext, ... }:

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
  };
  systemd.tmpfiles.settings."10-sudo-lectures"."/var/db/sudo/lectured/1000".f = {
    user = "root";
    group = "root";
    mode = "-";
  };
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
  # Suboptimal, but fixes application menus
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.xfce.garcon}/etc/xdg/menus/xfce-applications.menu";
}
