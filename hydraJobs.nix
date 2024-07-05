{self, ...}: {
  flake.hydraJobs = {
    a = self.nixosConfigurations.x1.config.system.build.toplevel;
  };
}
