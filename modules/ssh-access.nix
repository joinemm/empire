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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdrlMsN+yqst4ThORcm9Jf2g5JNVWcjIkzkRow8BCChZjC/EqbVCAeN8LfdGniefre49KNc40IxJENnrtu3TitFHDBhuRYrFJ1csK6dD1pZBeFrCPrWjr7b1e9PwusQddI7Xi/amSf8XlmBvDMXRnvqFnBD4xNdmd5DMPDi2Q5FjzNqlsuEAPPegahb0OoGIYGbwUfHtVDtUtuN6oYUYuQbiz92Fjpy5tyz/Bb4Wrw7iphL5nITM0l/BdtGFv4D/UUa3cju74xIm5Qi93qBaNXhQwRVv1c2pzBQvwQltjQYxV9kvTcG24cI+iS/XUaalKV539q/wXaC9h5aKEYyMn+TzuATZsvcP45JQeZpkMcOsCCKroIvOzeizfYbIW7+T5rdhkC0PFfmo1/WYQ4fcbukgEBa3OjuG8LGZvHo7BLj46s+qW3dV+WemhIHiFXYI9sTaXzL4pxgXI1DwYaz1tSMOQTOh+rYqjhUaaqsQqLdbcdBlrpInIvZqpC3VUkTyU= join@cerberus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6EoeiMBiiwfGJfQYyuBKg8rDpswX0qh194DUQqUotL joonas@buutti"
  ];
}
