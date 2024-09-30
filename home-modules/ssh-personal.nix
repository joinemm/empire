{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      miso = {
        hostname = "5.161.128.99";
        user = "root";
      };
      alexandria.hostname = "65.21.249.145";
      byzantium.hostname = " 65.108.222.239";
      kyoto.hostname = "192.168.1.3";
    };
  };
}
