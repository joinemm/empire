{
  self,
  lib,
  ...
}: {
  flake.githubActions.matrix =
    # can't build aarch64 on github
    lib.subtractLists ["archimedes"]
    (builtins.attrNames self.nixosConfigurations);
}
