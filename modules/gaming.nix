{
  pkgs,
  inputs,
  user,
  ...
}:
let
  # Usage in steam launch options: game-wrapper %command%
  # Enables gamescope, AMD RADV driver, mangohud and obs game capture
  game-wrapper = pkgs.writeShellScriptBin "game-wrapper" ''
    export OBS_VKCAPTURE=1
    export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
    export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"
    gamemoderun gamescope -r 144 -w 3440 -h 1440 -f -F pixel --mangoapp --adaptive-sync --force-grab-cursor -- obs-gamecapture "$@"
  '';
in
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
    };

    gamemode.enable = true;
    gamescope.enable = true;

    # for minecraft
    java.enable = true;
  };

  services.pipewire.lowLatency.enable = false;

  users.users.${user.name}.extraGroups = [ "gamemode" ];

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

  environment.systemPackages =
    with pkgs;
    [
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      protontricks
      protonplus
      libva-utils
      gst_all_1.gstreamer
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ]
    ++ [
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
      game-wrapper
    ];
}
