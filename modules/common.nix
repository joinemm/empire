{
  pkgs,
  user,
  ...
}: {
  system.stateVersion = "23.11";

  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays {inherit pkgs;};
  };

  nix.settings = {
    substituters = [
      "https://cache.vedenemo.dev"
    ];
    trusted-public-keys = [
      "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
    ];
    trusted-users = ["${user}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  systemd.services.nix-gc.serviceConfig = {
    Restart = "on-failure";
  };

  programs.zsh.enable = true;

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

  console = {
    font = "ter-v32n";
    packages = [pkgs.terminus_font];
  };

  hardware.enableAllFirmware = true; 

  security.sudo = {
    extraConfig = ''
      Defaults lecture = never
      Defaults passwd_timeout=0
    '';
  };

  security.polkit.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
    firewall.enable = true;
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    # zsh completions
    pathsToLink = ["/share/zsh"];
    shells = [pkgs.zsh];
  };
}
