{pkgs, ...}: {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  dconf.enable = true;
  nixpkgs.config.allowUnfree = true;
  systemd.user.startServices = "sd-switch";

  services = {
    easyeffects.enable = true;
    udiskie.enable = true;
  };

  home.packages = with pkgs; [
    # development
    python3
    rustup
    lua
    nodejs
    actionlint
    gitmoji-cli
    pre-commit

    # gui apps
    spotify
    darktable
    slack
    pavucontrol
    pcmanfm
    obsidian
    gimp
    chromium
    prusa-slicer

    # cli apps
    ffmpeg-full
    glow # render markdown on the cli
  ];
}
