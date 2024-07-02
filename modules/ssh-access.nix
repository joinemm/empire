{user, ...}: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      ClientAliveInterval = 60;
    };
  };

  networking.firewall.allowedTCPPorts = [22];

  services.fail2ban.enable = true;

  users.users.${user.name}.openssh.authorizedKeys.keys = user.sshKeys;
}
