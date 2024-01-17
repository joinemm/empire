{pkgs, ...}: {
  systemd.services."keyd" = {
    enable = true;
    description = "keyd key remapping daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Restart = "on-failure";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    leftalt = overload(vim, leftalt)

    [vim]
    h = left
    k = up
    j = down
    l = right
  '';

  users.groups."keyd" = {};
}
