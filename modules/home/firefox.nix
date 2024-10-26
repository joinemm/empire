{
  programs.firefox = {
    enable = true;
    policies = {
      DownloadDirectory = "\${home}/downloads";
      OfferToSaveLogins = false;
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
  };
}
