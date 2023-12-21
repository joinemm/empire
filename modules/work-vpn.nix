{pkgs, ...}: {
  environment = {
    etc."ppp/options".text = "ipcp-accept-remote";
    systemPackages = with pkgs; [
      openfortivpn
    ];
  };

  services = {
    openvpn.servers = {
      ficoloVPN = {
        autoStart = false;
        config = "config /home/joonas/work/tii/credentials/ficolo_vpn.ovpn";
      };
    };
  };
}
