{
  services.redshift = {
    enable = true;
    tray = false;
    dawnTime = "6:00-8:00";
    duskTime = "22:00-23:30";
    temperature = {
      day = 6500;
      night = 3300;
    };
  };
}
