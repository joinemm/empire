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

          # add scripts to path
          (pkgs.writeScriptBin "list-nodes" ../scripts/list-nodes.sh)
          (pkgs.writeScriptBin "install" ../scripts/install.sh)
          (pkgs.writeScriptBin "init-secrets" ../scripts/init-secrets.sh)
        ];
      };
    };
}
