inputs: let
namespace = "internal";
  lib0 = inputs.nixpkgs.lib;
  lib1 = import ./lib { lib = lib0; inherit inputs namespace; };
  lib = lib0.extend (finalLib: prevLib: { "${namespace}" = lib1; });
  system = builtins.elemAt (import inputs.systems) 0;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in {
  lib = lib1;
  nixosModules = lib.internal.flake.genModules {
    src = ./modules/nixos;
  };
  nixosConfigurations = {
    pixels-pc = lib.nixosSystem {
      inherit system;
      specialArgs = inputs;
      modules = [
        { "${namespace}" = lib1; }
        lib.internal.flake.genPkgOverlay { inherit namespace; packages = inputs.self.packages.x86_64-linux; }
        ./systems/pixels-pc
      ] ++ (with inputs.self.nixosModules; [
        base
        desktop
      ]) ++ (with inputs; [
        nixpkgs-xr.nixosModules.nixpkgs-xr
      ]) ++ (with inputs.nixos-hardware.nixosModules; [
        common-pc
        common-pc-ssd
        common-cpu-amd
        common-gpu-amd
      ]);
    };
  };
  formatter.${system} = pkgs.nixpkgs-fmt;
  packages.${system} = lib.internal.flake.genPackages {
    src = ./packages;
    inherit (pkgs) newScope;
  };
}