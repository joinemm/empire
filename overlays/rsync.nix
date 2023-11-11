{pkgs, ...}: final: prev: {
  # fix for https://github.com/NixOS/nixpkgs/issues/265014
  rsync = prev.rsync.overrideAttrs (_: _: {
    hardeningDisable = ["fortify"];
  });
}
