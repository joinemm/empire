{ pkgs, ... }:
{
  # make startx use xsession like any other display manager
  home.file.".xinitrc".source = pkgs.writeShellScript ".xinitrc" ''
    source .xsession
  '';

  xsession = {
    enable = true;
    initExtra = # bash
      ''
        [[ -f ~/.fehbg ]] && ~/.fehbg
        xset s 900 900
        xset r rate 250 30
        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate dracula)"

        # programs
        birdtray &
      '';
  };
}
