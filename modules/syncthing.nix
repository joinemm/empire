{
  user,
  config,
  lib,
  ...
}: {
  services.syncthing = {
    user = user.name;
    enable = true;
    group = "users";

    dataDir = lib.mkDefault user.home;
    configDir = "${user.home}/.config/syncthing";

    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "x1" = {id = "HQZRDQW-EUEUGNR-M4X3NLQ-KSQXR27-UKTBJIE-GXXVN3K-AW7IW4D-ZHGKXQD";};
        "zeus" = {id = "75G5FQ2-4573B6V-CIAQYBB-AFBHADB-CAQVWCW-K3FMRP4-DAENIRD-B35BEQA";};
        "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
        "pixel" = {id = "ZZOWVUE-R3U54UG-2OVST4D-Z4HTZTL-PVEU42C-ZERQKK6-FY4XG32-PTZJQA2";};
      };
      folders = let
        dir = config.services.syncthing.dataDir;
      in {
        "camera" = {
          enable = lib.mkDefault false;
          id = "25yyh-2i2sq";
          path = "${dir}/camera";
          devices = ["samsung" "andromeda" "zeus"];
        };
        "code" = {
          enable = lib.mkDefault false;
          id = "asqhs-gxzl4";
          path = "${dir}/code";
          devices = ["andromeda" "zeus" "x1"];
          ignorePerms = false;
        };
        "documents" = {
          enable = lib.mkDefault false;
          id = "rg3sy-y9wvv";
          path = "${dir}/documents";
          devices = ["samsung" "andromeda" "zeus" "x1" "pixel"];
        };
        "mobile-downloads" = {
          enable = lib.mkDefault false;
          id = "m7oev-edqfh";
          path = "${dir}/mobile-downloads";
          devices = ["samsung" "andromeda" "zeus"];
        };
        "mobile-screenshots" = {
          enable = lib.mkDefault false;
          id = "6517n-x3hlt";
          path = "${dir}/mobile-screenshots";
          devices = ["samsung" "andromeda" "zeus"];
        };
        "notes" = {
          enable = lib.mkDefault false;
          id = "jmdvx-nzh9p";
          path = "${dir}/notes";
          devices = ["andromeda" "zeus" "x1" "pixel"];
        };
        "pictures" = {
          enable = lib.mkDefault false;
          id = "zuaps-ign9t";
          path = "${dir}/pictures";
          devices = ["andromeda" "samsung" "x1" "zeus"];
        };
        "videos" = {
          enable = lib.mkDefault false;
          id = "hmrxy-xkgrb";
          path = "${dir}/videos";
          devices = ["andromeda" "samsung" "x1" "zeus"];
        };
        "work" = {
          enable = lib.mkDefault false;
          id = "meugk-eipcy";
          path = "${dir}/work";
          devices = ["andromeda" "x1" "zeus"];
          ignorePerms = false;
        };
      };
    };
  };
}
