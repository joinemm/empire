# Reusable NixOS modules
{
  bin = import ./bin.nix;
  bluetooth = import ./bluetooth.nix;
  bootloader = import ./bootloader.nix;
  common = import ./common.nix;
  docker = import ./docker.nix;
  gaming = import ./gaming.nix;
  gui = import ./gui.nix;
  keyd = import ./keyd.nix;
  laptop = import ./laptop.nix;
  nginx = import ./nginx.nix;
  sound = import ./sound.nix;
  ssh-access = import ./ssh-access.nix;
  syncthing = import ./syncthing.nix;
  trackpoint = import ./trackpoint.nix;
  work-vpn = import ./work-vpn.nix;
}
