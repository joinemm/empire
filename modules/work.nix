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

  nix.settings = {
    substituters = [
      "https://cache.vedenemo.dev"
    ];
    trusted-public-keys = [
      "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
    ];
  };
}
