{pkgs, ...}: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      settings.General = {
        Experimental = true;
        FastConnectable = true;
      };
    };

    # remember the bluetooth device profile when reconnecting
    pulseaudio.extraConfig = ''
      load-module module-card-restore restore_bluetooth_profile=true
    '';
  };

  services.blueman.enable = true;
}
