{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home.nix
  ];
  home = {
    # if this is set then it's read only and I can't change wallpapers from file manager
    # file.".wallpaper".source = ./wallpaper;
  };
}
