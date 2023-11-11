{pkgs, ...}: final: prev: {
  # nixpkgs is not updated because there has been no new release
  # see https://github.com/google/xsecurelock/issues/163
  xsecurelock = prev.xsecurelock.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "xsecurelock";
      rev = "15e9b01b02f64cc40f02184f001849971684ce15";
      sha256 = "sha256-k7xkM53hLJtjVDkv4eklvOntAR7n1jsxWHEHeRv5GJU=";
    };
  });
}
