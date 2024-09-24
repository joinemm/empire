{ pkgs, user, ... }:
{
  services.openvpn.servers = {
    ficolo = {
      autoStart = false;
      config = "config ${user.home}/work/tii/credentials/ficolo-vpn.ovpn";
    };
  };

  networking.openconnect.interfaces = {
    tii = {
      autoStart = false;
      gateway = "access.tii.ae";
      protocol = "gp";
      user = "joonas.rautiola";
      passwordFile = "${user.home}/work/tii/credentials/tiivpn-password";
    };
  };

  environment.etc."ppp/options".text = "ipcp-accept-remote";
  systemd.services.openfortivpn-office = {
    description = "Office VPN";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.openfortivpn}/bin/openfortivpn --config ${user.home}/work/tii/credentials/office-vpn.config";
      Restart = "always";
      Type = "notify";
    };
  };

  nix.settings = {
    extra-substituters = [ "https://cache.vedenemo.dev?priority=43" ];
    extra-trusted-public-keys = [ "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E=" ];
  };

  networking.hosts = {
    "10.151.12.79" = [ "confluence.tii.ae" ];
    "10.151.12.77" = [ "jira.tii.ae" ];
  };
}
