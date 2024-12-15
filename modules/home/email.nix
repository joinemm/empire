{ pkgs, ... }:
{
  home.packages = with pkgs; [ birdtray ];

  programs.thunderbird = {
    enable = true;
    profiles."default".isDefault = true;
  };

  accounts.email.maildirBasePath = "mail";

  accounts.email.accounts = {
    "mail@joinemm.dev" = {
      primary = true;
      thunderbird.enable = true;
      realName = "Joinemm";
      address = "mail@joinemm.dev";
      userName = "mail@joinemm.dev";
      signature.text = "Joinemm";

      imap = {
        host = "imap.migadu.com";
        port = 993;
      };
      smtp = {
        host = "smtp.migadu.com";
        port = 465;
        tls.useStartTls = true;
      };
    };
  };

  accounts.calendar.accounts = {
    "personal" = {
      remote = {
        type = "caldav";
        url = "https://dav.joinemm.dev";
        userName = "joonas";
      };
    };
  };
}
