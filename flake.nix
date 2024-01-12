{
  description = "A Special Snowflake :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bin = {
      url = "github:joinemm/bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nixvim,
    nixos-hardware,
    nix-index-database,
    bin,
  } @ inputs: let
    inherit (self) outputs;
    specialArgs = {inherit inputs outputs;};
  in {
    nixosModules = import ./modules;
    homeManagerModules = import ./home-modules;

    nixosConfigurations = {
      buutti = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/buutti/configuration.nix];
      };
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
  };
}
