{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "buutti" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./hosts/buutti/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.joonas = import ./hosts/buutti/home.nix;
            };
          }
        ];
      };
      "unikie" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./hosts/unikie/configuration.nix
        ];
      };
      "oolacile" = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./hosts/oolacile/configuration.nix
	];
      };
    };
  };
}
