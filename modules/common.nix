{pkgs, ...}: {
  system.stateVersion = "23.11";

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

  environment.systemPackages = with pkgs; [
    git
    neofetch
    file
    bottom
    jq
    fd # faster find
    dig
  ];
}
