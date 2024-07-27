{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      miso = {
        hostname = "5.161.128.99";
        user = "root";
      };
      andromeda = {
        hostname = "65.21.184.54";
        user = "captain";
      };
      apollo = {
        hostname = "65.21.249.145";
      };
    };
  };
}
