{pkgs, ...}: [
  (import ./dwm.nix {inherit pkgs;})
  (import ./dwmblocks.nix {inherit pkgs;})
]
