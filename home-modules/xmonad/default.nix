{pkgs, ...}: {
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  home.packages = [
    (pkgs.haskellPackages.ghcWithPackages (p:
      with p; [
        xmonad
        xmonad-contrib
        xmonad-extras
      ]))
  ];
}
