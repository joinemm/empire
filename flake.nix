{
  description = "A Special Snowflake :3";

  nixConfig = {
    extra-substituters = [
      "https://nix-gaming.cachix.org?priority=42"
    ];
    extra-trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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

    flake-root = {
      url = "github:srid/flake-root";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.flake-root.flakeModule
        ./hosts
        ./devshell.nix
        ./githubMatrix.nix
        ./deployments.nix
      ];

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        packages = {
          rpi_export = pkgs.callPackage ./pkgs/rpi_export {};
          headscale-alpha = pkgs.callPackage ./pkgs/headscale {};
        };

        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            shellcheck.enable = true;
            ormolu.enable = true;
            jsonfmt.enable = true;
          };
          settings.formatter.ormolu = {
            options = ["--ghc-opt" "-XImportQualifiedPost"];
          };
        };
      };
    };
}
