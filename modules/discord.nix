{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];
}
