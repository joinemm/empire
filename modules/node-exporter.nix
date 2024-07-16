{config, ...}: {
  networking.firewall = {
    allowedTCPPorts = [config.services.prometheus.exporters.node.port];
    allowedUDPPorts = [config.services.prometheus.exporters.node.port];
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = ["processes" "tcpstat" "interrupts"];
  };
}
