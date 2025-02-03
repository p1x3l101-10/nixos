{
  outputs = inputs: inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;
    supportedSystems = [ "x86_64-linux" ];
    outputs-builder = channels: {
      formatter = channels.nixpkgs.nixpkgs-fmt;
    };
    channels-config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import inputs.nur { inherit pkgs; };
      };
      config = {
        yt-dlp.withAlias = true;
      };
    };

    systems = {
      modules.nixos = with inputs; (with self.nixosModules; [
        base
        desktop
      ]) ++ ([
        ({ config = { nix.registry.nixpkgs.flake = inputs.self.pkgs.x86_64-linux.nixpkgs; }; })
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            sharedModules = with inputs; [
              self.homeModules.options
              nur.hmModules.nur
            ];
          };
        }
        { nixpkgs.overlays = [ inputs.nur.overlay ]; }
      ]) ++ (with inputs; [
        sops-nix.nixosModules.sops
        lanzaboote.nixosModules.lanzaboote
        impermanence.nixosModules.impermanence
        disko.nixosModules.disko
        nur.nixosModules.nur
        declarative-flatpak.nixosModules.declarative-flatpak
        nixos-boot.nixosModules.default
      ]);
      hosts = {
        pixels-pc.modules = with inputs.nixos-hardware.nixosModules; [
          common-cpu-amd
          common-gpu-amd
          common-pc
          common-pc-ssd
        ];
        pixels-laptop.modules = with inputs.nixos-hardware.nixosModules; [
          common-cpu-intel
          common-pc-laptop
          common-pc-laptop-ssd
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib/92803a029b5314d4436a8d9311d8707b71d9f0b6?narHash=sha256-oJQZv2MYyJaVyVJY5IeevzqpGvMGKu5pZcCCJvb%2Bxjc%3D";
      #url = "github:snowfallorg/lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";

    declarative-flatpak = {
      url = "github:GermanBread/declarative-flatpak";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-boot.url = "github:Melkor333/nixos-boot";
  };

  description = "My NixOS master config file";

  nixConfig = {
    substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org/" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };
}
