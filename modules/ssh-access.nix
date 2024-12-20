{ user, lib, ... }:
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
    hostKeys = lib.mkForce [
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  users.users.${user.name}.openssh.authorizedKeys.keys = user.sshKeys;

  services.fail2ban.enable = true;

  security.sudo.wheelNeedsPassword = false;
}
