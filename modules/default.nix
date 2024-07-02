# Reusable NixOS modules
{
  bluetooth = import ./bluetooth.nix;
  common = import ./common.nix;
  desktop = import ./desktop;
  docker = import ./docker.nix;
  gaming = import ./gaming.nix;
  hetzner = import ./hetzner.nix;
  keyd = import ./keyd.nix;
  laptop = import ./laptop.nix;
  locale = import ./locale.nix;
  nginx = import ./nginx.nix;
  remotebuild = import ./remotebuild.nix;
  ssh-access = import ./ssh-access.nix;
  syncthing = import ./syncthing.nix;
  transmission = import ./transmission.nix;
  work-vpn = import ./work-vpn.nix;
  yubikey = import ./yubikey.nix;
}
