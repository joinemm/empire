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
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.resolved.enable = true;

  users.users."${user}".extraGroups = ["networkmanager"];

  environment.systemPackages = with pkgs; [
    wirelesstools
  ];
}
