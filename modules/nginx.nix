{
  config,
  user,
  ...
}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = user.email;
  };

  security.dhparams = {
    enable = true;
    params.nginx = {};
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    resolver.addresses = config.networking.nameservers;
    sslDhparam = config.security.dhparams.params.nginx.path;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
