{
  description = "A Special Snowflake :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bin = {
      url = "github:joinemm/bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    treefmt-nix,
    ...
  }: let
    user = {
      name = "joonas";
      fullName = "Joonas Rautiola";
      email = "joonas@rautiola.co";
      gpgKey = "0x090EB48A4669AA54";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlFqSQFoSSuAS1IjmWBFXie329I5Aqf71QhVOnLTBG+ joonas@x1"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3h/Aj66ndKFtqpQ8H53tE9KbbO0obThC0qbQQKFQRr joonas@zeus"
      ];
      home = "/home/${user.name}";
    };
    specialArgs = {inherit inputs outputs user;};
    inherit (self) outputs;
  in {
    nixosModules = import ./modules;
    homeManagerModules = import ./home-modules;

    nixosConfigurations = {
      x1 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/x1/configuration.nix];
      };
      zeus = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/zeus/configuration.nix];
      };
      apollo = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/hetzner/apollo/configuration.nix];
      };
      monitoring = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/hetzner/monitoring/configuration.nix];
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
