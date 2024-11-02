{ pkgs, user, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        # backend = "iwd";
        powersave = true;
      };
      dns = "systemd-resolved";
    };

    firewall.enable = true;
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      Cache=no
    '';
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  users.users."${user.name}".extraGroups = [ "networkmanager" ];

  environment.systemPackages = with pkgs; [ wirelesstools ];
}
