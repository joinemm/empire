{ inputs, lib, ... }:
let
  user = {
    name = "joonas";
    fullName = "Joonas Rautiola";
    email = "joonas@rautiola.co";
    gpgKey = "0x090EB48A4669AA54";
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlFqSQFoSSuAS1IjmWBFXie329I5Aqf71QhVOnLTBG+ joonas@athens"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3h/Aj66ndKFtqpQ8H53tE9KbbO0obThC0qbQQKFQRr joonas@rome"
    ];
    home = "/home/${user.name}";
  };
  modules = import ../modules;
  specialArgs = {
    inherit inputs user modules;
  };
in
{
  flake.nixosConfigurations = {
    athens = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./athens ];
    };
    rome = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./rome ];
    };
    alexandria = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./alexandria ];
    };
    byzantium = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./byzantium ];
    };
    kyoto = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./kyoto ];
    };
  };
}
