{
  pkgs,
  ...
}: {
  system.stateVersion = "23.11";

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  # disable beeping motherboard speaker
  boot.blacklistedKernelModules = ["pcspkr"];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

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

      trusted-users = ["root" "@wheel"];
      experimental-features = ["nix-command" "flakes"];

      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
    };
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

  environment.systemPackages = with pkgs; [
    git
    fastfetch
    file
    bottom
    jq
    fd # faster find
    dig
    rsync
    pciutils
    usbutils
    ffmpeg-full
  ];
}
