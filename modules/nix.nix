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
}
