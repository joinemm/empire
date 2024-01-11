let
  username = "jrautiola";
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      ci-server = {
        hostname = "172.18.20.100";
        user = username;
      };
      build1 = {
        hostname = "172.18.20.102";
        user = username;
      };
      build2 = {
        hostname = "172.18.20.103";
        user = username;
      };
      "build3 172.18.20.104" = {
        hostname = "172.18.20.104";
        user = username;
      };
      build4 = {
        hostname = "172.18.20.105";
        user = username;
      };
      "prbuilder 172.18.20.106" = {
        hostname = "172.18.20.106";
        user = username;
      };
      gerrit = {
        hostname = "172.18.20.107";
        user = username;
      };
      "monitoring 172.18.20.108" = {
        hostname = "172.18.20.108";
        user = username;
      };
      "binarycache 172.18.20.109" = {
        hostname = "172.18.20.109";
        user = username;
      };
      awsarm = {
        hostname = "13.51.226.233";
        user = username;
        port = 20220;
      };
      jenkins3 = {
        hostname = "172.18.16.33";
        user = "tc-agent03";
      };
    };
  };
}
