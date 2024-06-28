{
  pkgs,
  lib,
  user,
  ...
}: {
  services.pcscd.enable = true;

  security.pam = {
    u2f = {
      enable = true;
      interactive = true;
      cue = true;
      authFile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
        user
        ":CH2warz8nhqVvjt1i9KETBbhjqFWtrLwDBPauuOBl0mpz56ZbKvShUGMaxqFW2GEm61QEiD6yYewf30E+FsLoA==,MBex4QFLLmCtXqxQ4zMWb5IS+POy/6m9fvzHDbhCbQmAkLNMTQQQhb9u46p6S+grUrjZHhHSEQnvxWGOtQPUrg==,es256,+presence" # keychain
        ":EL+Z2Yi7tq+FcDt38GH/OMISPz53Xw38+LD0uoT+YGOJ4m4eh6gtxzNK75qii4VW0N/eNdOGQcMoTXUqyI5YZg==,NZhvywFlYqwEH+4tEiYUL8gA54CbqrxcBfSaOUQQQRf9MjCSxHoPypPUwTwjRkZqckeK2xPwebgh8LP9n0as4Q==,es256,+presence" # backup
      ]);
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
