inputs: let
namespace = "internal";
  lib0 = inputs.nixpkgs.lib;
  lib1 = import ./lib { lib = lib0; inherit inputs namespace; };
  lib = lib0.extend (finalLib: prevLib: { "${namespace}" = lib1; });
  system = builtins.elemAt (import inputs.systems) 0;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  common-modules = with inputs; [
    lanzaboote.nixosModules.lanzaboote
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
    self.nixosModules.base
  ];
in {
  lib = lib1;
  nixosModules = lib.internal.flake.genModules {
    src = ./modules/nixos;
  };
  nixosConfigurations = {
    pixels-pc = lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs };
      modules = [
        { lib."${namespace}" = lib1; }
        (lib.internal.flake.genPkgOverlay { inherit namespace; packages = inputs.self.packages.x86_64-linux; })
        ./systems/pixels-pc
      ] ++ (with inputs; [
        self.nixosModules.desktop
        nixpkgs-xr.nixosModules.nixpkgs-xr
      ]) ++ (with inputs.nixos-hardware.nixosModules; [
        common-pc
        common-pc-ssd
        common-cpu-amd
        common-gpu-amd
      ]) ++ common-modules;
    };
  };
  formatter.${system} = pkgs.nixpkgs-fmt;
  packages.${system} = lib1.flake.genPackages ./packages pkgs.newScope;
}