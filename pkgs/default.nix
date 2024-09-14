{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        rpi_export = pkgs.callPackage ./rpi_export { };
        headscale-alpha = pkgs.callPackage ./headscale { };
        actual-server = pkgs.callPackage ./actual-server { };
        keymap-drawer = pkgs.python3Packages.callPackage ./keymap-drawer { };
      };
    };
}
