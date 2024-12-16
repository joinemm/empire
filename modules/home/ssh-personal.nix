{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      miso = {
        hostname = "5.161.128.99";
        user = "root";
      };
      oxygen.hostname = "65.21.249.145";
      hydrogen.hostname = " 65.108.222.239";
      zinc.hostname = "192.168.1.3";
      nickel.hostname = "192.168.1.4";
    };
  };
}
