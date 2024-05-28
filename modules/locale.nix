{
  time.timeZone = "Europe/Helsinki";

  i18n = {
    defaultLocale = "fi_FI.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
    };
  };

  location.provider = "geoclue2";
  services.geoclue2.enable = true;
}
