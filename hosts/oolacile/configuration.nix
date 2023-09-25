{ config, pkgs, ... }:

let 
	user = "joonas";
	publicKeys = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdrlMsN+yqst4ThORcm9Jf2g5JNVWcjIkzkRow8BCChZjC/EqbVCAeN8LfdGniefre49KNc40IxJENnrtu3TitFHDBhuRYrFJ1csK6dD1pZBeFrCPrWjr7b1e9PwusQddI7Xi/amSf8XlmBvDMXRnvqFnBD4xNdmd5DMPDi2Q5FjzNqlsuEAPPegahb0OoGIYGbwUfHtVDtUtuN6oYUYuQbiz92Fjpy5tyz/Bb4Wrw7iphL5nITM0l/BdtGFv4D/UUa3cju74xIm5Qi93qBaNXhQwRVv1c2pzBQvwQltjQYxV9kvTcG24cI+iS/XUaalKV539q/wXaC9h5aKEYyMn+TzuATZsvcP45JQeZpkMcOsCCKroIvOzeizfYbIW7+T5rdhkC0PFfmo1/WYQ4fcbukgEBa3OjuG8LGZvHo7BLj46s+qW3dV+WemhIHiFXYI9sTaXzL4pxgXI1DwYaz1tSMOQTOh+rYqjhUaaqsQqLdbcdBlrpInIvZqpC3VUkTyU= join@cerberus"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6EoeiMBiiwfGJfQYyuBKg8rDpswX0qh194DUQqUotL joonas@buutti"
];
in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
	enable = true;
  	efiSupport = false;
  device = "/dev/sda";
};

  networking = {
hostName = "oolacile"; # Define your hostname.
nameservers = ["1.1.1.1"];
firewall.enable = true;
#firewall.allowedTCPPorts = [ ... ];
#  firewall.allowedUDPPorts = [ ... ];
};
   systemd.network.enable = true;  
systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";
    networkConfig.DHCP = "ipv4";
};
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
  };

  users = {
	groups.sysadmin.members = [ "${user}" ];
users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
 openssh.authorizedKeys.keys = publicKeys;
initialPassword = "asdf";
  };
  users.root = {
	initialHashedPassword = "";
 openssh.authorizedKeys.keys = publicKeys;
  };
};

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];

  services.openssh.enable = true;
virtualisation.docker.enable = true;

    system.stateVersion = "23.05"; # Did you read the comment?
}

