{
  inputs,
  pkgs,
  user,
  ...
}: let
  homeModules = import ../../home-modules;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit user;};

    users."${user.name}" = {
      imports = pkgs.lib.flatten [
        (with homeModules; [
          default-modules
        ])
        inputs.nixvim.homeManagerModules.nixvim
        inputs.nix-index-database.hmModules.nix-index
      ];

      services.poweralertd.enable = true;
    };
  };
}
