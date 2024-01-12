{pkgs, ...}: _final: prev: {
  dwm = prev.dwm.overrideAttrs (_old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwm";
      rev = "c0b431747eb4afa4f31b1dce79ff53253f2c4b63";
      sha256 = "sha256-YfMJVKMdNR9NiR3OK7CrHdrC3k9NLZ1UTI24KTa0Wt4=";
    };
    nativeBuildInputs = with pkgs; [
      xorg.libX11
      xorg.libX11.dev
      xorg.libXft
      xorg.libXinerama
    ];
  });
}
