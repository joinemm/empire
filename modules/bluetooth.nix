{pkgs, ...}: {
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      powerOnBoot = false;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  services.blueman.enable = true;
}
