{ inputs, ... }:

{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];
  users.users.pixel = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "ipfs"
      "kvm"
      "tablet"
      "adbusers"
    ];
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
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
      ] {
        imports = with inputs.self.homeModules; [
          desktop
        ];
      }
    );
  };
}
