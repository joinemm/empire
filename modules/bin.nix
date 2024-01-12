{
  inputs,
  system,
  ...
}: {
  environment.systemPackages = builtins.attrValues inputs.bin.packages.${system};
}
