{
  services.redshift = {
    enable = true;
    tray = false;
    dawnTime = "6:00-7:00";
    duskTime = "21:00-22:00";
    temperature = {
      day = 6500;
      night = 3000;
    };
  };
}
