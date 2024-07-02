{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
