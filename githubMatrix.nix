{self, ...}: {
  flake.githubActions.matrix = {
    host = builtins.attrNames self.nixosConfigurations;
  };
}
