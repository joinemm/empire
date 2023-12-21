{
  description = "A Special Snowflake :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nixvim,
    nixos-hardware,
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosModules = import ./modules;
    homeManagerModules = import ./modules-home;

    nixosConfigurations = {
      buutti = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/buutti/configuration.nix];
      };
      unikie = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/unikie/configuration.nix];
      };
      hetzner = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/hetzner/configuration.nix
          disko.nixosModules.disko
        ];
      };
    };
  };
}
