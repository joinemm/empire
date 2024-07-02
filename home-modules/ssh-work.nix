{lib, ...}: {
  programs.ssh = {
    enable = true;

    matchBlocks = let
      # default username when one is not specified
      user = "jrautiola";
    in
      {
        "*.cloudapp.azure.com" = {
          inherit user;
        };
      }
      // builtins.listToAttrs (map (attrs: {
          name = "${attrs.host} ${attrs.hostname}";
          value = lib.mergeAttrsList [
            {inherit user;}
            (builtins.removeAttrs attrs ["host"])
          ];
        })
        [
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
            host = "build3";
            hostname = "172.18.20.104";
          }
          {
            host = "build4";
            hostname = "172.18.20.105";
          }
          {
            host = "prbuilder";
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
          {
            host = "gerrit";
            hostname = "172.18.20.107";
          }
          {
            host = "jenkins3";
            hostname = "172.18.16.33";
            user = "tc-agent03";
          }
          {
            host = "testagent";
            hostname = "172.18.16.60";
          }
          {
            host = "hetzarm";
            hostname = "65.21.20.242";
          }
          {
            host = "ghaf-log";
            hostname = "95.217.177.197";
          }
        ]);
  };
}
