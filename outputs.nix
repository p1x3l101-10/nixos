inputs:
let
  namespace = "internal";
  # TODO: Avoid lib pollution
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
      packages = lib1.flake.genPackages ./packages pkgs.newScope {
        ext = {
          inherit inputs;
        };
      };
    }
  ) // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system:
  let
    specialArgs = lib.fix (final: {
      ext = lib.fix (finalExt: {
        inherit inputs system;
        stable = lib.fix (finalPkgs: {
          input = inputs.nixpkgs-stable;
          inherit (finalPkgs.input) lib;
          pkgs = finalPkgs.input.legacyPackages."${system}";
          unfreePkgs = finalExt.rawPkgs {
            nixpkgs = finalPkgs.input;
            config = { allowUnfree = true; };
          };
        });
        unstable = lib.fix (finalPkgs: {
          input = inputs.nixpkgs;
          inherit (finalPkgs.input) lib;
          pkgs = finalPkgs.input.legacyPackages."${system}";
          unfreePkgs = finalExt.rawPkgs {
            nixpkgs = finalPkgs.input;
            config = { allowUnfree = true; };
          };
        });
        rawPkgs = { nixpkgs ? finalExt.unstable.input, config }: (
          import nixpkgs {
            inherit system config;
          }
        );
        assets = (lib.internal.attrsets.mapDirTree ./assets);
        lib = inputs.self.lib;
      });
      eLib = final.ext.lib; # Conveniance
      inherit (final.ext) inputs; # Backwards compat
    });
    common-modules = with inputs; [
      nixos-cli.nixosModules.nixos-cli
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
          noctalia.nixosModules.default
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
          noctalia.nixosModules.default
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
      iso = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./systems/hetzner-vps
        ] ++ common-modules;
      };
    };
  }
)
