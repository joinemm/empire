{ pkgs, inputs, ... }:
{
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
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      extraPackages = with pkgs; [ gamemode ];
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
      extraPackages = with pkgs; [ libva ];
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
