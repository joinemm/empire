{self, ...}: let
  inherit (self.inputs) deploy-rs;

  x86 = {
    apollo = {
      hostname = "65.21.249.145";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.apollo;
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

  aarch64 = {
    archimedes = {
      hostname = "192.168.1.3";
      remoteBuild = true;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.archimedes;
      };
    };
  };
in {
  flake = {
    deploy.nodes = x86 // aarch64;
    checks = {
      x86_64-linux = deploy-rs.lib.x86_64-linux.deployChecks {nodes = x86;};
      aarch64-linux = deploy-rs.lib.aarch64-linux.deployChecks {nodes = aarch64;};
    };
  };
}
