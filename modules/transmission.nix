{
  pkgs,
  user,
  ...
}: {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    inherit user;
    settings = {
      ratio-limit = 0;
      ratio-limit-enabled = true;
      download-dir = "/home/${user}/downloads";
    };
  };
}
