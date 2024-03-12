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

  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlFqSQFoSSuAS1IjmWBFXie329I5Aqf71QhVOnLTBG+ joonas@x1"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3h/Aj66ndKFtqpQ8H53tE9KbbO0obThC0qbQQKFQRr joonas@zeus"
  ];
}
