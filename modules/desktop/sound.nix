{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # https://www.reddit.com/r/linux/comments/1em8biv/psa_pipewire_has_been_halving_your_battery_life/
    wireplumber.extraConfig."10-disable-camera.conf" = {
      "wireplumber.profiles".main."monitor.libcamera" = "disabled";
    };
  };

  security.rtkit.enable = true;

  hardware.pulseaudio.daemon.config = {
    default-sample-format = "float32le";
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio
    playerctl
  ];
}
