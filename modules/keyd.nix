{ pkgs, ... }:
{
  systemd.services."keyd" = {
    enable = true;
    description = "keyd key remapping daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "on-failure";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };

  # when left alt is held down, hjkl acts as arrow keys
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    leftalt = overloadt2(vim, leftalt, 200)

    [vim]
    h = left
    k = up
    j = down
    l = right
  '';

  users.groups."keyd" = { };
}
