{ pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 8443 ];
    allowedUDPPorts = [ 8443 ];
  };

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-6_0;
    openFirewall = true;
  };
}
