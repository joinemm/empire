{pkgs, ...}: final: prev: {
  dwmblocks = prev.dwmblocks.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwmblocks";
      rev = "fcfeb01a584ece03015ecdca24d75b2be6607072";
      sha256 = "sha256-vn/aU5DAiz+TShtAu3xvbIbFWf/waVTqMuVDmJgC1gM=";
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
