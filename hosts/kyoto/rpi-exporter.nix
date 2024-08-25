{ pkgs, ... }:
let
  rpi_export = pkgs.callPackage ../../pkgs/rpi_export { };
in
{
  users = {
    groups = {
      rpi-exporter = { };
      vcio = { };
    };
    users.rpi-exporter = {
      isSystemUser = true;
      group = "rpi-exporter";
      extraGroups = [ "vcio" ];
    };
  };

  # Allow access to /dev/vcio for vcio group
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "vcio-udev-rules";
      destination = "/etc/udev/rules.d/99-vcio.rules";
      text = ''
        SUBSYSTEM=="misc", KERNEL=="vcio", GROUP="vcio", MODE="0660"
      '';
    })
  ];

  systemd.services.prometheus-rpi-exporter = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      user = "rpi-exporter";
      ExecStart = ''
        ${rpi_export}/bin/rpi_exporter -addr=:9110
      '';
    };
  };
}
