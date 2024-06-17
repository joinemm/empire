{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    mangohud
    shipwright
    mupen64plus
  ];

  # makes steam download a lot faster
  home.file.".steam/steam/steam_dev.cfg".text = ''
    @nClientDownloadEnableHTTP2PlatformLinux 0
    @fDownloadRateImprovementToAddAnotherConnection 1.0
  '';
}
