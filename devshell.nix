{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "snowflake";
        packages = with pkgs; [
          sops
          ssh-to-age
          gnupg
          deploy-rs
        ];
      };
    };
}
