{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  name = "rpi_export";
  version = "e2db87b68a191979b61c07986c493a2c1f433ed2";

  src = fetchFromGitHub {
    owner = "cavaliercoder";
    repo = name;
    rev = version;
    sha256 = "sha256-Ul8EejStFPOdNKfUn4YVV1sPLhh5mgdn9xuqys1Wr/g=";
  };

  vendorHash = null;
}
