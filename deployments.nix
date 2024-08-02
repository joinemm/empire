{self, ...}: let
  inherit (self.inputs) deploy-rs;
in {
  flake.deploy.nodes = {
    apollo = {
      hostname = "65.21.249.145";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.apollo;
      };
    };

    archimedes = {
      hostname = "192.168.1.3";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.archimedes;
      };
    };

    monitoring = {
      hostname = "65.108.222.239";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.monitoring;
      };
    };
  };
}
