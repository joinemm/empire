# Reusable Home-manager modules
rec {
  easyeffects = import ./easyeffects;
  polybar = import ./polybar;
  xmonad = import ./xmonad;
  common = import ./common.nix;
  dark-mode = import ./dark-mode.nix;
  discord = import ./discord.nix;
  dunst = import ./dunst.nix;
  firefox = import ./firefox.nix;
  flameshot = import ./flameshot.nix;
  git = import ./git.nix;
  gtk = import ./gtk.nix;
  hidpi = import ./hidpi.nix;
  imv = import ./imv.nix;
  mpv = import ./mpv.nix;
  neovim = import ./neovim.nix;
  picom = import ./picom.nix;
  redshift = import ./redshift.nix;
  rofi = import ./rofi.nix;
  ssh-personal = import ./ssh-personal.nix;
  ssh-work = import ./ssh-work.nix;
  starship = import ./starship.nix;
  wezterm = import ./wezterm.nix;
  xdg = import ./xdg.nix;
  xinitrc = import ./xinitrc.nix;
  xresources = import ./xresources.nix;
  yazi = import ./yazi.nix;
  zathura = import ./zathura.nix;
  zsh = import ./zsh.nix;

  default-modules = [
    easyeffects
    polybar
    xmonad
    common
    dark-mode
    discord
    dunst
    firefox
    flameshot
    git
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
    zsh
  ];
}
