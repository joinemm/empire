{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        sops
        ssh-to-age
        gnupg
      ];
    };
  };
}
