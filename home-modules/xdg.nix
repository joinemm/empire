{
  user,
  pkgs,
  ...
}: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "/home/${user}";
      templates = "/home/${user}";
      publicShare = "/home/${user}";
      documents = "/home/${user}/documents";
      download = "/home/${user}/downloads";
      music = "/home/${user}/music";
      pictures = "/home/${user}/pictures";
      videos = "/home/${user}/videos";
    };

    desktopEntries."transmission-magnet" = {
      name = "Transmission add torrent";
      exec = ''add-torrent %u'';
      mimeType = ["x-scheme-handler/magnet"];
    };

    desktopEntries."nsxiv" = {
      name = "nsxiv";
      exec = ''${pkgs.nsxiv}/bin/nsxiv -a %F'';
      mimeType = ["image/gif"];
    };
  };
}
