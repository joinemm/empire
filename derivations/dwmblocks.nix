{
  stdenv,
  lib,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "dwmblocks";
  version = "fcfeb01a584ece03015ecdca24d75b2be6607072";

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
