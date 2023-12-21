{
  common = import ./common.nix;
  dracula = import ./dracula.nix;
  neovim = import ./neovim.nix;
  zsh = import ./zsh.nix;
  xresources = import ./xresources.nix;
  wezterm = import ./wezterm.nix;
  mimeapps = import ./mimeapps.nix;
  xinitrc = import ./xinitrc.nix;
  dunst = import ./dunst.nix;
  picom = import ./picom.nix;
  git = import ./git.nix;
  ssh-personal = import ./ssh-personal.nix;
  ssh-work = import ./ssh-work.nix;
}
