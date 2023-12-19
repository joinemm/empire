{
  description = "A Special Snowflake :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nixvim,
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosModules = import ./modules;
    homeModules = import ./homeModules;
    nixosConfigurations = let
      specialArgs = {inherit inputs outputs;};
    in {
      buutti = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/buutti/configuration.nix];
      };
    };
  };
}
