{ pkgs, user, ... }:
{
  services.transmission = {
    enable = true;
    user = user.name;
    package = pkgs.transmission_4;
    settings = {
      ratio-limit = 0;
      ratio-limit-enabled = true;
      download-dir = "${user.home}/downloads";
    };
  };
}
