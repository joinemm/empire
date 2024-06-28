{
  pkgs,
  lib,
  user,
  ...
}: {
  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  security.pam = {
    u2f = {
      enable = true;
      interactive = true;
      cue = true;
      origin = "pam://yubi";

      # generated with pamu2fcfg -n -o pam://yubi
      authFile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
        user
        ":oM+DMf4lQT2nIg1oXQEt7lenFcX2FK00qI0yy2UPdG1mIXgRuoCve+ah4sY0VeVbBm+O40ULv84r6C5XgcE7Ww==,lqYsszFYfRWN/afLKa2LLOvYSt/cwLLbau08M1w4l8kluyC5jPBjrswub+U6cHyU1mi0s8KJdSKZNQQYCpquZw==,es256,+presence" # keychain
        ":nxUeYfbMHp0/1IsZXzDTj5uU/fDkbDLUPjGTQXYz60QpPCbI8St5jsTSTNfCBaNys6BMICQO1AWkF41OE6RVQg==,gUIRzPMKE05QCk/tUvlr0d6fpfQum5uhCYmpx0+zc/Qf+AH4nllDwG1P7R4GN07KhFjm2Fn3+sko4Pkcrh7TJA==,es256,+presence" # backup
      ]);
    };

    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager # provides ykman
    cryptsetup
  ];
}
