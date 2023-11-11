{pkgs, ...}: final: prev: {
  dwm = prev.dwm.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwm";
      rev = "6dc953fe30ff5109e8282277e29eddff3437d064";
      sha256 = "XzZE6DTp0gUoRnJGKcFYXCo3288u/F1ImgHfcGX9O5A=";
    };
    nativeBuildInputs = with pkgs; [
      xorg.libX11
      xorg.libX11.dev
      xorg.libXft
      xorg.libXinerama
    ];
  });
}
