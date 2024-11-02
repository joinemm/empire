{ pkgs, user, ... }:
{
  # https://github.com/jtroo/kanata/wiki/Avoid-using-sudo-on-Linux

  users.users.${user.name}.extraGroups = [
    "uinput"
    "input"
  ];

  boot.kernelModules = [ "uinput" ];

  environment.systemPackages = [ pkgs.kanata ];

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  systemd.user.services.kanata = {
    path = [
      pkgs.xorg.xset
    ];
    serviceConfig = {
      ExecStart = "${pkgs.kanata}/bin/kanata -c ${./keymap.kbd}";
      Environment = [
        "DISPLAY=:0"
      ];
    };
  };
}
