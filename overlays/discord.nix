{pkgs, ...}: final: prev: {
  discord = prev.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };
}
