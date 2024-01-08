{pkgs, ...}: final: prev: {
  dwm = prev.dwm.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwm";
      rev = "357fded817f8d734f4ddcc47463532c7256e5371";
      sha256 = "sha256-fHmp0YMA1SUqVlyajZKVFuz38Sz6iwsXp2oehnaGbBo=";
    };
    nativeBuildInputs = with pkgs; [
      xorg.libX11
      xorg.libX11.dev
      xorg.libXft
      xorg.libXinerama
    ];
  });
}
