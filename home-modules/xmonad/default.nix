{pkgs, ...}: {
  xsession.windowManager.xmonad = {
    enable = true;
    extraPackages = haskellPackages:
      with haskellPackages; [
        xmonad-contrib
        containers
      ];
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };
}
