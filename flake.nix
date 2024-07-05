{
  description = "A Special Snowflake :3";

  nixConfig = {
    allow-import-from-derivation = true;
    substituters = [
      "https://nix-gaming.cachix.org?priority=42"
      "https://joinemm.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "joinemm.cachix.org-1:aMZBO1baRjhaI5QzePLelFz/GJ82fZOjmiHQwCl1FxI="
    ];
  };

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

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./hosts
        ./githubMatrix.nix
        ./hydraJobs.nix
      ];

      perSystem = {pkgs, ...}: {
        formatter =
          inputs.treefmt-nix.lib.mkWrapper
          pkgs
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
    };
}
