{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;

    # https://www.reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
    wireplumber = {
      enable = true;
      extraConfig."10-disable-camera.conf" = {
        "wireplumber.profiles".main."monitor.libcamera" = "disabled";
      };
    };

    extraConfig = {
      # set higher pipewire quantum to fix issues with crackling sound
      pipewire."92-quantum" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 512;
        };
      };

      client."10-resample" = {
        "stream.properties" = {
          "resample.quality" = 10;
        };
      };
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    playerctl
  ];
}
