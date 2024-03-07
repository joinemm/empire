{pkgs, ...}: {
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    # for minecraft
    java.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  # Add opengl/vulkan support
  hardware.opengl.extraPackages = with pkgs; [
    libva
  ];

  # Xbox wireless controller driver
  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
    vulkan-tools
    mangohud
    # open source minecraft launcher
    prismlauncher
  ];
}
