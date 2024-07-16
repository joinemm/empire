{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  boot.kernelParams = [
    # may improve performance in some badly optimised games
    "split_lock_detect=off"
  ];

  programs = {
    steam = {
      enable = true;
      platformOptimizations.enable = true;

      # Use GE proton within steam
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];

      # Fixes libgamemode.so: cannot open shared object file: No such file or directory
      extraPackages = with pkgs; [
        gamemode
      ];
    };

    gamemode.enable = true;

    # for minecraft
    java.enable = true;
  };

  services.pipewire.lowLatency.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      # Add vulkan video encoding support
      extraPackages = with pkgs; [
        libva
      ];
    };

    # Xbox wireless controller driver
    xone.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    protontricks
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
  ];
}
