{pkgs, ...}: _final: prev: {
  dwmblocks = prev.dwmblocks.overrideAttrs (_old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwmblocks";
      rev = "367ae57afd8d4cfdc663c239febb9b85638502d0";
      sha256 = "sha256-X51HAexp7Dmr7TZHdiqfu+B4YzTiEOsBqAkxw16zPJc=";
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
  });
}
