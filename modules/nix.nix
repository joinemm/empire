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
        "https://numtide.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cache.vedenemo.dev"
      ];
      trusted-public-keys = [
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      ];

      trusted-users = ["root" "@wheel"];
      experimental-features = ["nix-command" "flakes"];

      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
    };
  };
}
