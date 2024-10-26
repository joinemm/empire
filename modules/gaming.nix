{
  pkgs,
  inputs,
  user,
  ...
}:
let
  # Usage in steam launch options: game-wrapper %command%
  game-wrapper = pkgs.writeShellScriptBin "game-wrapper" ''
    export OBS_VKCAPTURE=1

    # Force the use of RADV driver. gamescope refuses to start without this (at least on my system).
    export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
    export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"

    # save LD_PRELOAD value.
    # It is set to empty for gamescope, but reset back to it's original value for the game process.
    # This fixes stuttering after 30 minutes of gameplay, but doesn't break steam overlay.
    export LD_PRELOAD_SAVED="$LD_PRELOAD"
    export LD_PRELOAD=""

    gamemoderun \
      gamescope -r 144 -w 3440 -h 1440 -f -F pixel \
      --mangoapp \
      --adaptive-sync \
      --force-grab-cursor \
      -- \
      env LD_PRELOAD=$LD_PRELOAD_SAVED \
      obs-gamecapture \
      "$@"
  '';
in
{
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
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
