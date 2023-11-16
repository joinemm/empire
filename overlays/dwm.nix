{pkgs, ...}: final: prev: {
  dwm = prev.dwm.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwm";
      rev = "63df44db7959ef735f330031fede4c98c2488136";
      sha256 = "sha256-uwv1qMpLw5Gqjohr1zd88qUAEJR2NDNR4Bz9D90HpA8=";
    };
    nativeBuildInputs = with pkgs; [
      xorg.libX11
      xorg.libX11.dev
      xorg.libXft
      xorg.libXinerama
    ];
  });
}
