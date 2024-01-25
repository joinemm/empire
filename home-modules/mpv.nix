{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      thumbfast
      uosc
    ];
    config = {
      loop-file = "inf";
    };
  };
}
