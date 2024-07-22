{
  lib,
  breakpointHook,
  mkYarnPackage,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
  fixup-yarn-lock,
  yarn2nix-moretea,
  fetchYarnDeps,
  stdenv,
}: let
  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "traggo";
    repo = "server";
    rev = "v${version}";
    sha256 = "sha256-+gVmv/cbnt0Xix4mfd9LCTl3v8Sc0dsNv6FNh5gNN9w=";
  };
  node-modules = fetchYarnDeps {
    yarnLock = "${src}/ui/yarn.lock";
    hash = "sha256-BDQ7MgRWBRQQfjS5UCW3KJ0kJrkn4g9o4mU0ZH+vhX0=";
  };

  frontend = stdenv.mkDerivation {
    pname = "traggo-ui";
    inherit version;
    src = src;

    configurePhase = ''
      export HOME=$(mktemp -d)
    '';

    nativeBuildInputs = [
      fixup-yarn-lock
      pkgs.yarn
      pkgs.nodejs
      gqlgen
    ];

    buildPhase = ''
      gqlgen
      cd ui
      fixup-yarn-lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${node-modules}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
      patchShebangs node_modules
      export PATH=$PWD/node_modules/.bin:$PATH
      yarn --offline run generate
      yarn --offline run build
    '';

    installPhase = ''
      cp -r ui/build/* $out
    '';
  };
  gqlgen = buildGoModule rec {
    pname = "gqlgen";
    version = "0.17.49";
    src = fetchFromGitHub {
      owner = "99designs";
      repo = "gqlgen";
      rev = "v${version}";
      sha256 = "sha256-dHKK21xIc7C0Ei/4+WHrVaDMFikZxHP6hTA8zF9ZEZ8=";
    };

    vendorHash = "sha256-1NxgK/4ccUqf0m3rJkM0FXKK5wNJmCeCNnV2FyZVRoQ=";
    subPackages = ["graphql"];
  };
in
  buildGoModule {
    pname = "traggo";
    inherit src version;

    nativeBuildInputs = [gqlgen];
    vendorHash = "sha256-+gVmv/cbnt0Xix4TTT9LCTl3v8Sc0dsNv6FNh5gNN9w=";

    preBuild = ''
      mkdir build
      cp -r ${frontend} build
      gqlgen
    '';

    tags = [
      "netgo"
      "osusergo"
      "sqlite_omit_load_extension"
    ];

    ldflags = [
      "-s"
      "-w"
      "-linkmode external"
      "-extldflags \"-static\""
      "-X main.BuildMode=prod"
      "-X main.BuildVersion=${version}"
      "-o build/traggo-server"
    ];
  }
