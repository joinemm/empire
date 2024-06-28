# Reusable NixOS modules
{
  bin = import ./bin.nix;
  bluetooth = import ./bluetooth.nix;
  bootloader = import ./bootloader.nix;
  common = import ./common.nix;
  docker = import ./docker.nix;
  fonts = import ./fonts.nix;
  gaming = import ./gaming.nix;
  gui = import ./gui.nix;
  keyd = import ./keyd.nix;
  laptop = import ./laptop.nix;
  locale = import ./locale.nix;
  networking = import ./networking.nix;
  nginx = import ./nginx.nix;
  nix = import ./nix.nix;
  remotebuild = import ./remotebuild.nix;
  sound = import ./sound.nix;
  ssh-access = import ./ssh-access.nix;
  syncthing = import ./syncthing.nix;
  transmission = import ./transmission.nix;
  users = import ./users.nix;
  work-vpn = import ./work-vpn.nix;
  yubikey = import ./yubikey.nix;
}
