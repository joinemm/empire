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

    dataDir = lib.mkDefault "/home/${user}/";
    configDir = "/home/${user}/.config/syncthing";

    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
        "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
        "windows" = {id = "3D3Z5N4-JLIWTGO-IJFSPLG-VWEJNH6-WLQDBMH-UCIMAWB-ONWDSP6-7NCL7AU";};
        "unikie" = {id = "J4ASID7-BTVUC22-MMVY2GJ-A6YIMQI-PMBRV7S-FIN7OTV-PNPCV62-6GY7AAF";};
        "buutti" = {id = "WSCI2BT-CE75BLT-RLRMHDO-SARY35B-I7KGQ4I-2U6S6OP-IWAO6UH-MMOU7Q6";};
      };
      folders = let
        dir = config.services.syncthing.dataDir;
      in {
        "camera" = {
          enable = lib.mkDefault false;
          id = "25yyh-2i2sq";
          path = "${dir}/camera";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "code" = {
          enable = lib.mkDefault false;
          id = "asqhs-gxzl4";
          path = "${dir}/code";
          devices = ["andromeda" "cerberus" "buutti"];
          ignorePerms = false;
        };
        "documents" = {
          enable = lib.mkDefault false;
          id = "rg3sy-y9wvv";
          path = "${dir}/documents";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-downloads" = {
          enable = lib.mkDefault false;
          id = "m7oev-edqfh";
          path = "${dir}/mobile-downloads";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-screenshots" = {
          enable = lib.mkDefault false;
          id = "6517n-x3hlt";
          path = "${dir}/mobile-screenshots";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "notes" = {
          enable = lib.mkDefault false;
          id = "jmdvx-nzh9p";
          path = "${dir}/notes";
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
        };
        "pictures" = {
          enable = lib.mkDefault false;
          id = "zuaps-ign9t";
          path = "${dir}/pictures";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "videos" = {
          enable = lib.mkDefault false;
          id = "hmrxy-xkgrb";
          path = "${dir}/videos";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "work" = {
          enable = lib.mkDefault false;
          id = "meugk-eipcy";
          path = "${dir}/work";
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
          ignorePerms = false;
        };
      };
    };
  };
}
