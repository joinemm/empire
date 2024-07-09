{
  inputs,
  user,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit user inputs;};
    users."${user.name}" = let
      homeModules = import ../home-modules;
    in {
      imports = lib.flatten [homeModules.default-modules];
    };
  };
}
