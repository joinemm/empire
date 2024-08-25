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

    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = { };
        }
      ];
      "pulse.properties" = {
        "pulse.min.req" = "32/48000";
        "pulse.default.req" = "32/48000";
        "pulse.max.req" = "32/48000";
        "pulse.min.quantum" = "32/48000";
        "pulse.max.quantum" = "32/48000";
      };
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 1;
      };
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pulseaudio
    playerctl
  ];
}
