{
  description = "Illogical Impulse Hyprland Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ags.url = "github:Aylur/ags/v1";
    ags.inputs.nixpkgs.follows = "nixpkgs";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, ags, anyrun, systems, ... }: let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs (import systems);
  in {
    legacyPackages = eachSystem (
      system:
      import ./pkgs {
        pkgs = nixpkgs.legacyPackages.${system};
        ags = ags.packages.${system}.default;
      }
    );
    homeManagerModules.default = import ./modules self anyrun ags;
  };
}
