{
  pkgs,
  user,
  ...
}: {
  environment = {
    etc."ppp/options".text = "ipcp-accept-remote";
    systemPackages = [pkgs.openfortivpn];
  };

  services = {
    openvpn.servers = {
      ficoloVPN = {
        autoStart = false;
        config = "config ${user.home}/work/tii/credentials/ficolo_vpn.ovpn";
      };
    };
  };
}
