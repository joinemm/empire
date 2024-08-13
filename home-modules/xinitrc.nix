{pkgs, ...}: {
  # make startx use xsession like any other display manager
  home.file.".xinitrc".source = pkgs.writeShellScript ".xinitrc" ''
    source .xsession
  '';

  xsession = {
    enable = true;
    initExtra = ''
      [[ -f ~/.fehbg ]] && ~/.fehbg
      xset s 900 900
    '';
  };
}
