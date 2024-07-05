{
  self,
  lib,
  ...
}: {
  flake.githubActions.matrix = {
    host =
      # can't build aarch64 on github
      lib.subtractLists ["archimedes"]
      (builtins.attrNames self.nixosConfigurations);
  };
}
