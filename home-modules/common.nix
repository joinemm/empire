{ pkgs, ... }:
{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  systemd.user.startServices = "sd-switch";

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
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
    ffmpegthumbnailer # video thumbnails
    obsidian
    gimp
    chromium
    prusa-slicer
    nsxiv
    via
    freecad
    krita
    kepubify
    vlc

    # cli apps
    glow # render markdown on the cli
    nix-output-monitor
    (btop.override { rocmSupport = true; })
    onefetch

    # utils
    azure-cli
    tree
    rsync
    pciutils
    usbutils
    ffmpeg-full
    nix-diff
    p7zip
    yq-go
    file
    jq
    dig
  ];
}
