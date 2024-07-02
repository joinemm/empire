{
  lib,
  pkgs,
  user,
  ...
}: {
  # disable beeping motherboard speaker
  boot.blacklistedKernelModules = ["pcspkr"];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  console = {
    font = "ter-v24b";
    packages = [pkgs.terminus_font];
  };

  security = {
    polkit.enable = true;

    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults passwd_timeout=0
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://joinemm.cachix.org"
        "https://cache.vedenemo.dev"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "joinemm.cachix.org-1:aMZBO1baRjhaI5QzePLelFz/GJ82fZOjmiHQwCl1FxI="
        "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      ];

      trusted-users = ["root" "@wheel"];
      experimental-features = ["nix-command" "flakes"];

      max-jobs = 2;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
    };
  };

  users.users."${user.name}" = {
    isNormalUser = true;
    description = user.fullName;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment = {
    # fix completion for zsh
    pathsToLink = ["/share/zsh"];
    # allow both zsh and bash
    shells = [pkgs.bashInteractive pkgs.zsh];

    systemPackages = with pkgs; [
      git
      vim
      neofetch
      file
      bottom
      jq
      dig
    ];
  };
}
