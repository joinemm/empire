# Reusable NixOS modules
{
  laptop = import ./laptop.nix;
  common = import ./common.nix;
  bluetooth = import ./bluetooth.nix;
  gui = import ./gui.nix;
  syncthing = import ./syncthing.nix;
  work-vpn = import ./work-vpn.nix;
  ssh-access = import ./ssh-access.nix;
  nginx = import ./nginx.nix;
}
