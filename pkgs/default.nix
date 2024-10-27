{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        rpi-export = pkgs.callPackage ./rpi-export { };
        actual-server = pkgs.callPackage ./actual-server { };
        keymap-drawer = pkgs.python3Packages.callPackage ./keymap-drawer { };
      };
    };
}
