{
  inputs,
  outputs,
  pkgs,
  user,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users."${user}" = {
    imports = pkgs.lib.flatten [
      (with outputs.homeManagerModules; [
        (common {inherit pkgs user;})
        xresources
        (neovim {inherit pkgs user;})
        zsh
        wezterm
        xinitrc
        picom
        git
        ssh-personal
        ssh-work
        dunst
        rofi
        discord
        redshift
        (flameshot {inherit user;})
        starship
        imv
        yazi
        gtk
      ])
      inputs.nixvim.homeManagerModules.nixvim
      inputs.nix-index-database.hmModules.nix-index
    ];

    services = {
      easyeffects.enable = true;
      batsignal.enable = true;
      udiskie.enable = true;
      picom.backend = lib.mkForce "xrender";
    };
  };
}
