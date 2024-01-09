# Reusable Home-manager modules
{
  common = import ./common.nix;
  neovim = import ./neovim.nix;
  zsh = import ./zsh.nix;
  xresources = import ./xresources.nix;
  wezterm = import ./wezterm.nix;
  xinitrc = import ./xinitrc.nix;
  dunst = import ./dunst.nix;
  picom = import ./picom.nix;
  git = import ./git.nix;
  ssh-personal = import ./ssh-personal.nix;
  ssh-work = import ./ssh-work.nix;
  hidpi = import ./hidpi.nix;
  rofi = import ./rofi.nix;
  discord = import ./discord.nix;
  redshift = import ./redshift.nix;
  flameshot = import ./flameshot.nix;
  starship = import ./starship.nix;
  imv = import ./imv.nix;
  yazi = import ./yazi.nix;
  gtk = import ./gtk.nix;
}
