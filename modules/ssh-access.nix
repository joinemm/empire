{ user, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      ClientAliveInterval = 60;
    };
  };

  users.users.${user.name}.openssh.authorizedKeys.keys = user.sshKeys;

  services.fail2ban.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
