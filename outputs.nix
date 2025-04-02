inputs: let
  lib0 = inputs.nixpkgs.lib;
  lib1 = import ./lib { lib = lib0; inherit inputs; };
  namespace = "internal";
  lib = lib0.extend { "${namespace}" = lib1; };
  system = builtins.elemAt 0 inputs.systems;
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
        lib.internal.flake.genPkgOverlay { inherit namespace; inherit (inputs.self) packages; }
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
  formatter = pkgs.nixpkgs-fmt;
  packages = lib.internal.flake.genPackages {
    src = ./packages;
    inherit (pkgs) newScope;
  };
}