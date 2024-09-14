{ inputs, ... }:
{
  imports = with inputs; [
    flake-root.flakeModule
    treefmt-nix.flakeModule
  ];
  perSystem =
    { config, pkgs, ... }:
    {
      treefmt.config = {
        inherit (config.flake-root) projectRootFile;

        programs = {
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          deadnix.enable = true;
          statix.enable = true;
          shellcheck.enable = true;
          ormolu.enable = true;
          jsonfmt.enable = true;
        };

        settings.formatter.ormolu = {
          options = [
            "--ghc-opt"
            "-XImportQualifiedPost"
          ];
        };
      };

      formatter = config.treefmt.build.wrapper;
    };
}
