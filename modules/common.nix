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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays {inherit pkgs;};
  };

  nix = {
    settings = {
      substituters = [
        "https://cache.vedenemo.dev"
      ];
      trusted-public-keys = [
        "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      ];
      trusted-users = [user];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  systemd.services.nix-gc.serviceConfig = {
    Restart = "on-failure";
  };

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

  services.getty = {
    autologinUser = user;
    helpLine = "";
  };

  console = {
    font = "ter-v32n";
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
    audit.enable = true;
    auditd.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
}
