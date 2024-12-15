{ lib, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks =
      let
        user = "jrautiola";
      in
      {
        "*.cloudapp.azure.com" = {
          inherit user;
        };
      }
      // builtins.listToAttrs (
        map
          (attrs: {
            name = "${attrs.host} ${attrs.hostname}";
            value = lib.mergeAttrsList [
              { inherit user; }
              (builtins.removeAttrs attrs [ "host" ])
            ];
          })
          [
            # ficolo
            {
              host = "ci-server";
              hostname = "172.18.20.100";
            }
            {
              host = "build1";
              hostname = "172.18.20.102";
            }
            {
              host = "build2";
              hostname = "172.18.20.103";
            }
            {
              host = "build3";
              hostname = "172.18.20.104";
            }
            {
              host = "build4";
              hostname = "172.18.20.105";
            }
            {
              host = "himalia";
              hostname = "172.18.20.106";
            }
            {
              host = "gerrit";
              hostname = "172.18.20.107";
            }
            {
              host = "monitoring";
              hostname = "172.18.20.108";
            }
            {
              host = "binarycache";
              hostname = "172.18.20.109";
            }
            # on-prem
            {
              host = "testagent-dev";
              hostname = "172.18.16.33";
            }
            {
              host = "testagent-release";
              hostname = "172.18.16.32";
            }
            {
              host = "testagent-prod";
              hostname = "172.18.16.60";
            }
            # hetzner
            {
              host = "hetzarm";
              hostname = "65.21.20.242";
            }
            {
              host = "ghaf-log";
              hostname = "95.217.177.197";
            }
            {
              host = "ghaf-webserver";
              hostname = "37.27.204.82";
            }
            {
              host = "ghaf-proxy";
              hostname = "95.216.200.85";
            }
            {
              host = "ghaf-coverity";
              hostname = "135.181.103.32";
            }
          ]
      );
  };
}
