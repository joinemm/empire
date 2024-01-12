{
  user,
  config,
  lib,
  ...
}: {
  services.syncthing = {
    inherit user;
    enable = true;
    group = "users";

    dataDir = lib.mkDefault "/home/${user}";
    configDir = "/home/${user}/.config/syncthing";

    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
        "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
        "buutti" = {id = "WSCI2BT-CE75BLT-RLRMHDO-SARY35B-I7KGQ4I-2U6S6OP-IWAO6UH-MMOU7Q6";};
        "x1" = {id = "HQZRDQW-EUEUGNR-M4X3NLQ-KSQXR27-UKTBJIE-GXXVN3K-AW7IW4D-ZHGKXQD";};
        "zeus" = {id = "75G5FQ2-4573B6V-CIAQYBB-AFBHADB-CAQVWCW-K3FMRP4-DAENIRD-B35BEQA";};
      };
      folders = let
        dir = config.services.syncthing.dataDir;
      in {
        "camera" = {
          enable = lib.mkDefault false;
          id = "25yyh-2i2sq";
          path = "${dir}/camera";
          devices = ["samsung" "andromeda" "cerberus" "zeus"];
        };
        "code" = {
          enable = lib.mkDefault false;
          id = "asqhs-gxzl4";
          path = "${dir}/code";
          devices = ["andromeda" "cerberus" "buutti" "zeus" "x1"];
          ignorePerms = false;
        };
        "documents" = {
          enable = lib.mkDefault false;
          id = "rg3sy-y9wvv";
          path = "${dir}/documents";
          devices = ["samsung" "andromeda" "cerberus" "zeus" "x1"];
        };
        "mobile-downloads" = {
          enable = lib.mkDefault false;
          id = "m7oev-edqfh";
          path = "${dir}/mobile-downloads";
          devices = ["samsung" "andromeda" "cerberus" "zeus"];
        };
        "mobile-screenshots" = {
          enable = lib.mkDefault false;
          id = "6517n-x3hlt";
          path = "${dir}/mobile-screenshots";
          devices = ["samsung" "andromeda" "cerberus" "zeus"];
        };
        "notes" = {
          enable = lib.mkDefault false;
          id = "jmdvx-nzh9p";
          path = "${dir}/notes";
          devices = ["andromeda" "cerberus" "buutti" "zeus" "x1"];
        };
        "pictures" = {
          enable = lib.mkDefault false;
          id = "zuaps-ign9t";
          path = "${dir}/pictures";
          devices = ["andromeda" "cerberus" "samsung" "buutti" "x1" "zeus"];
        };
        "videos" = {
          enable = lib.mkDefault false;
          id = "hmrxy-xkgrb";
          path = "${dir}/videos";
          devices = ["andromeda" "cerberus" "samsung" "buutti" "x1" "zeus"];
        };
        "work" = {
          enable = lib.mkDefault false;
          id = "meugk-eipcy";
          path = "${dir}/work";
          devices = ["andromeda" "cerberus" "buutti" "x1" "zeus"];
          ignorePerms = false;
        };
      };
    };
  };
}
