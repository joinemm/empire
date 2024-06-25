{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    gamemode.enable = true;

    # for minecraft
    java.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      # Add vulkan support
      extraPackages = with pkgs; [
        libva
      ];
    };

    # Xbox wireless controller driver
    xone.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # vulkan
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    protontricks
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
  ];
}
