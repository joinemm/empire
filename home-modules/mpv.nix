{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      thumbfast
    ];
    config = {
      loop-file = "inf";
    };
  };
}
