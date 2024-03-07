{
  programs.firefox = {
    enable = true;
    policies = {
      DownloadDirectory = "\${home}/downloads";
      OfferToSaveLogins = false;
    };
  };
}
