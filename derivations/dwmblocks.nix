{
  stdenv,
  lib,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "dwmblocks";
  version = "8063cc7f4b9373dca1822dbe713a583a15ee9a28";

  src = pkgs.fetchFromGitHub {
    owner = "joinemm";
    repo = "dwmblocks";
    rev = version;
    sha256 = "sha256-8fzJdQU3u0BbNaBYfeoqU3zPGodjmykyWU+hYLvmgV0=";
  };

  nativeBuildInputs = with pkgs; [
    xorg.libX11
    xorg.libX11.dev
    xorg.libXft
    xorg.libXinerama
  ];

  unpackPhase = ''
    cp -r $src/* .
  '';

  installPhase = ''
    make PREFIX=$out DESTDIR="" install
  '';
}
