{
  pkgs,
  user,
  ...
}: {
  system.stateVersion = "23.11";

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.blacklistedKernelModules = ["pcspkr"];

  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;

  # allow old electron for obsidian version <= 1.4.16"
  # https://github.com/NixOS/nixpkgs/issues/273611
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nix = {
    settings = {
      substituters = [
        "https://cache.vedenemo.dev"
        "https://numtide.cachix.org"
      ];
      trusted-public-keys = [
        "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
      trusted-users = [user];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  programs.zsh.enable = true;

  environment = {
    pathsToLink = ["/share/zsh"];
    shells = [pkgs.zsh];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."${user}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager"];
      initialPassword = "asdf";
      home = "/home/${user}";
      shell = pkgs.zsh;
    };
  };

  # login automatically to my user
  # this is fine because the hard drive is encrypted anyway
  services.getty = {
    autologinUser = user;
    helpLine = "";
  };

  console = {
    font = "ter-v24b";
    packages = [pkgs.terminus_font];
  };

  security = {
    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults passwd_timeout=0
      '';
    };

    polkit.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
    busybox
    fastfetch
    file
    bottom
    xdotool
    playerctl
    pulseaudio
    jq
    fd # faster find
    dig
    rsync
    xclip
    pciutils
    usbutils
  ];
}
