{
  description = "A smaller flake that just exposes the pure(-ish) nix library that I tend to prefer";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };
  outputs = inputs: (
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          lib = inputs.nixpkgs.lib;
        in
        {
          apps = lib.fix (self: {
            update = {
              type = "app";
              program = pkgs.writeShellApplication {
                name = "subflake-updater";
                runtimeInputs = with pkgs; [
                  nix
                ];
                text = ''
                  nix flake lock --inputs-from ${./..}
                '';
              };
            };
            default = self.update;
          });
        }
      )
    // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system: {
      lib = import ./. { lib = inputs.nixpkgs.lib; namespace = "internal"; inherit inputs; };
    })
  );
}
