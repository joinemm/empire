{
  pkgs,
  user,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    firewall.enable = true;

    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.resolved.enable = true;

  users.users."${user.name}".extraGroups = ["networkmanager"];

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
