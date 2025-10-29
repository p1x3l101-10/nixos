inputs:
let
  namespace = "internal";
  lib0 = inputs.nixpkgs.lib;
  lib1 = import ./lib { lib = lib0; inherit inputs namespace; };
  lib = lib0.extend (finalLib: prevLib: { "${namespace}" = lib1; });
in
inputs.flake-utils.lib.eachDefaultSystem
  (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      formatter = pkgs.nixpkgs-fmt;
      packages = lib1.flake.genPackages ./packages pkgs.newScope { };
    }
  ) // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system:
  let
    specialArgs = lib.fix (self: {
      ext = {
        inherit inputs;
        assets = (lib.internal.attrsets.mapDirTree ./assets);
        inherit system;
      };
      inherit (self.ext) inputs; # Backwards compat
    });
    common-modules = with inputs; [
      lanzaboote.nixosModules.lanzaboote
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      stylix.nixosModules.stylix
      self.nixosModules.base
      self.nixosModules.module
      { lib."${namespace}" = lib1; }
      (lib.internal.flake.genPkgOverlay { inherit namespace; packages = inputs.self.packages.${system}; })
    ];
  in
  {
    inherit (specialArgs.ext) assets;
    lib = lib1;
    nixosModules = lib.internal.flake.genModules {
      src = ./modules/nixos;
    };
    homeModules = lib.internal.flake.genModules {
      src = ./modules/home;
    };
    nixosConfigurations = {
      pixels-pc = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
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
      pixels-laptop = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./systems/pixels-laptop
        ] ++ (with inputs; [
          self.nixosModules.desktop
        ]) ++ (with inputs.nixos-hardware.nixosModules; [
          common-pc-laptop
          common-pc-laptop-ssd
          common-cpu-intel
        ]) ++ common-modules;
      };
      pixels-server = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./systems/pixels-server
          inputs.self.nixosModules.server
        ] ++ (with inputs.nixos-hardware.nixosModules; [
          common-pc
          common-pc-ssd
          common-cpu-intel-cpu-only
        ]) ++ common-modules;
      };
      hetzner-vps = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./systems/hetzner-vps
        ] ++ (with inputs; (with self.nixosModules; [
          vps
        ]) ++ [ ]) ++ common-modules;
      };
    };
  }
)
