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

  home.packages = [
    (pkgs.haskellPackages.ghcWithPackages (p:
      with p; [
        xmobar
        xmonad
        xmonad-contrib
      ]))
  ];
}
