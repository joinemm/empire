{pkgs, ...}: [
  (import ./dwm.nix {inherit pkgs;})
  (import ./dwmblocks.nix {inherit pkgs;})
  (import ./discord.nix {inherit pkgs;})
  (import ./xsecurelock.nix {inherit pkgs;})
]
