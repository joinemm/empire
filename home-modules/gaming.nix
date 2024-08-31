{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
    mangohud
    kdePackages.kdenlive
  ];

  # makes steam download a lot faster
  home.file.".steam/steam/steam_dev.cfg".text = ''
    @nClientDownloadEnableHTTP2PlatformLinux 0
    @fDownloadRateImprovementToAddAnotherConnection 1.0
  '';

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-vkcapture
      obs-websocket
    ];
  };
}
