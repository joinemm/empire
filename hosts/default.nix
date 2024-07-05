{
  inputs,
  lib,
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
  modules = import ../modules;
  specialArgs = {inherit inputs user modules;};
in {
  flake.nixosConfigurations = {
    x1 = lib.nixosSystem {
      inherit specialArgs;
      modules = [./x1/configuration.nix];
    };
    zeus = lib.nixosSystem {
      inherit specialArgs;
      modules = [./zeus/configuration.nix];
    };
    apollo = lib.nixosSystem {
      inherit specialArgs;
      modules = [./hetzner/apollo/configuration.nix];
    };
    monitoring = lib.nixosSystem {
      inherit specialArgs;
      modules = [./hetzner/monitoring/configuration.nix];
    };
    archimedes = lib.nixosSystem {
      inherit specialArgs;
      modules = [./archimedes/configuration.nix];
    };
  };
}
