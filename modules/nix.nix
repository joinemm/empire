{
  nixpkgs.config.allowUnfree = true;

  # allow old electron for obsidian version <= 1.4.16"
  # https://github.com/NixOS/nixpkgs/issues/273611
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

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
}
