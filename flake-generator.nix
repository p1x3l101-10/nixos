{
  inputs = (
    let
      dep = { url, deps ? [], addNixpkgs ? true }: (
        {
          inherit url;
          inputs = (builtins.builtins.listToAttrs (map
            (x:
              {
                name = x;
                value = {
                  follows = "${x}";
                };
              }
            )
            (deps ++ (if (addNixpkgs) then ["nixpkgs"] else []))
          ));
        }
      );
    in
    {
      # Nixpkgs versions
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Primary nixpkgs
      nixpkgs-stable.follows = "nixpkgs-25_11"; # Shim for whatever version of nixpkgs stable I want to follow
      nixpkgs-25_11.url = "github:NixOS/nixpkgs/nixos-25.11"; # The real version, avoid overriding/depending on this without good reason
      # Modules
      home-manager = dep { url = "github:nix-community/home-manager"; };
      stylix = dep { url = "github:nix-community/stylix"; deps = [ "systems" "nur" "flake-parts" ]; };
      nix-flatpak.url = "github:gmodena/nix-flatpak";
      lanzaboote = dep { url = "github:nix-community/lanzaboote"; };
      disko = dep { url = "github:nix-community/disko"; };
      impermanence.url = "github:nix-community/impermanence";
      nixpak = dep { url = "github:nixpak/nixpak"; deps = [ "flake-parts" ]; };
      nixpkgs-xr = dep { url = "github:nix-community/nixpkgs-xr"; deps = [ "flake-utils" "systems" ]; };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      nur = dep { url = "github:nix-community/NUR"; deps = [ "flake-parts" ]; };
      nixvim = dep { url = "github:nix-community/nixvim"; deps = [ "systems" "flake-parts" ]; };
      nixcord = dep { url = "github:FlameFlag/nixcord"; deps = [ "flake-parts" "flake-compat" ]; };
      app2unit = dep { url = "github:soramanew/app2unit"; };
      # Software and module
      zen-browser = dep { url = "github:0xc000022070/zen-browser-flake"; deps = [ "home-manager" ]; };
      # Software
      hyprland = dep { url = "github:hyprwm/Hyprland"; deps = [ "nixpkgs" "systems" ]; };
      hyprland-plugins = dep { url = "github:hyprwm/hyprland-plugins"; deps = [ "hyprland" ]; addNixpkgs = false; };
      nix-autobahn = dep { url = "github:Lassulus/nix-autobahn"; deps = [ "flake-utils" ]; };
      fjordlauncher = dep { url = "github:unmojang/FjordLauncher"; };
      xStarbound = dep { url = "github:xStarbound/xStarbound"; };
      millennium = dep { url = "github:SteamClientHomebrew/Millennium?dir=packages/nix"; };
      noctalia = dep { url = "github:noctalia-dev/noctalia-shell"; };
      # Other used flakes
      systems.url = "github:nix-systems/x86_64-linux";
      flake-utils = dep { url = "github:numtide/flake-utils"; deps = [ "systems" ]; addNixpkgs = false; };
      # External deps
      flake-parts = dep { url = "github:hercules-ci/flake-parts"; };
      flake-compat.url = "github:edolstra/flake-compat";
    }
  );
}