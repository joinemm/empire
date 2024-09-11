# Reusable Home-manager modules
rec {
  easyeffects = ./easyeffects;
  polybar = ./polybar;
  xmonad = ./xmonad;
  common = ./common.nix;
  discord = ./discord.nix;
  dunst = ./dunst.nix;
  firefox = ./firefox.nix;
  flameshot = ./flameshot.nix;
  gaming = ./gaming.nix;
  git = ./git.nix;
  gpg = ./gpg.nix;
  gtk = ./gtk.nix;
  hidpi = ./hidpi.nix;
  imv = ./imv.nix;
  mpv = ./mpv.nix;
  neovim = ./neovim.nix;
  picom = ./picom.nix;
  redshift = ./redshift.nix;
  rofi = ./rofi.nix;
  ssh-personal = ./ssh-personal.nix;
  ssh-work = ./ssh-work.nix;
  starship = ./starship.nix;
  wezterm = ./wezterm.nix;
  xdg = ./xdg.nix;
  xinitrc = ./xinitrc.nix;
  xresources = ./xresources.nix;
  yazi = ./yazi.nix;
  zathura = ./zathura.nix;
  zen = ./zen.nix;
  zsh = ./zsh.nix;

  default-modules = [
    easyeffects
    polybar
    xmonad
    common
    discord
    dunst
    firefox
    flameshot
    gaming
    git
    gpg
    gtk
    imv
    mpv
    neovim
    picom
    redshift
    rofi
    ssh-personal
    ssh-work
    starship
    wezterm
    xdg
    xinitrc
    xresources
    yazi
    zathura
    zen
    zsh
  ];
}
