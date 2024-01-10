{pkgs, ...}: {
  systemd.services."keyd" = {
    enable = true;
    description = "keyd key remapping daemon";
    unitConfig = {
      Requires = "local-fs.target";
      After = "local-fs.target";
      Restart = "on-failure";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };

  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    leftalt = layer(vim)

    [vim]
    h = left
    k = up
    j = down
    l = right
  '';

  users.groups."keyd" = {};
}
