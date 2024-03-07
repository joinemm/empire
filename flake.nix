{
  description = "A Special Snowflake :3";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    nixpkgs = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    bin = {
      url = "github:joinemm/bin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    treefmt-nix,
    ...
  }: let
    inherit (self) outputs;
    user = "joonas";
    specialArgs = {inherit inputs outputs user;};
  in {
    nixosModules = import ./modules;
    homeManagerModules = import ./home-modules;

    nixosConfigurations = {
      unikie = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/unikie/configuration.nix];
      };
      x1 = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/x1/configuration.nix];
      };
      zeus = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/zeus/configuration.nix];
      };
      hetzner = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/hetzner/configuration.nix];
      };
    };

    formatter.x86_64-linux =
      treefmt-nix.lib.mkWrapper
      nixpkgs.legacyPackages.x86_64-linux
      {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true; # nix formatter https://github.com/kamadorueda/alejandra
          deadnix.enable = true; # removes dead nix code https://github.com/astro/deadnix
          statix.enable = true; # prevents use of nix anti-patterns https://github.com/nerdypepper/statix
          shellcheck.enable = true; # lints shell scripts https://github.com/koalaman/shellcheck
        };
      };
  };
}
