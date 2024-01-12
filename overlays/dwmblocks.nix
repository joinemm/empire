{pkgs, ...}: _final: prev: {
  dwmblocks = prev.dwmblocks.overrideAttrs (_old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwmblocks";
      rev = "5eb42c9b33247bea07d7e64c460d628c244fbd00";
      sha256 = "sha256-UT6O/xXfQVDacFAOUlOkClp44wkXv07fiWhtZeep5KI=";
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
