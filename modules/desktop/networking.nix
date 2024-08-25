{ pkgs, user, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = true;
      };
    };

    firewall.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  users.users."${user.name}".extraGroups = [ "networkmanager" ];

  environment.systemPackages = with pkgs; [ wirelesstools ];
}
