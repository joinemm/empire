{
  services.transmission = {
    enable = true;
    user = "joonas";
    settings = {
      ratio-limit = 0;
      ratio-limit-enabled = true;
      download-dir = "/home/joonas/downloads";
    };
  };
}
