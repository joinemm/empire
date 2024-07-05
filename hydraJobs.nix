{self, ...}: {
  flake.hydraJobs = {
    x1 = self.nixosConfigurations.x1.config.system.build.toplevel;
  };
}
