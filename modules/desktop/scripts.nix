{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = builtins.attrValues inputs.bin.packages.${pkgs.system};
}
