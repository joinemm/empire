{
  inputs,
  lib,
  self,
  ...
}:
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
  specialArgs = {
    inherit inputs user self;
  };
in
{
  flake.nixosConfigurations = {
    carbon = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./carbon ];
    };
    cobalt = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./cobalt ];
    };
    oxygen = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./oxygen ];
    };
    hydrogen = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./hydrogen ];
    };
    zinc = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./zinc ];
    };
    nickel = lib.nixosSystem {
      inherit specialArgs;
      modules = [ ./zinc ];
    };
  };
}
