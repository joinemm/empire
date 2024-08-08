{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.attic.packages.${pkgs.system}.attic-client
  ];

  sops.secrets.attic_auth_token.owner = "root";

  systemd.services.attic-watch-store = {
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "nss-lookup.target"];
    requires = ["network-online.target"];
    environment.HOME = "/var/lib/attic-watch-store";
    path = [inputs.attic.packages.${pkgs.system}.attic-client];

    serviceConfig = {
      DynamicUser = true;
      MemoryHigh = "5%";
      MemoryMax = "10%";
      LoadCredential = "auth-token:${config.sops.secrets.attic_auth_token.path}";
      StateDirectory = "attic-watch-store";
    };

    script = ''
      set -eux -o pipefail
      ATTIC_TOKEN=$(< $CREDENTIALS_DIRECTORY/auth-token)
      attic login joinemm https://attic.joinemm.dev $ATTIC_TOKEN
      attic use cache
      exec attic watch-store cache
    '';
  };
}
