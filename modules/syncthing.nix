{user, ...}: {
  services.syncthing = {
    enable = true;
    inherit user;
    group = "users";
    openDefaultPorts = true;
    dataDir = "/home/${user}/";
    configDir = "/home/${user}/.config/syncthing";
    # overrides any folders added or deleted through the WebUI
    overrideDevices = true;
    overrideFolders = true;
    settings.devices = {
      "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
      "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
      "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
      "windows" = {id = "3D3Z5N4-JLIWTGO-IJFSPLG-VWEJNH6-WLQDBMH-UCIMAWB-ONWDSP6-7NCL7AU";};
      "unikie" = {id = "J4ASID7-BTVUC22-MMVY2GJ-A6YIMQI-PMBRV7S-FIN7OTV-PNPCV62-6GY7AAF";};
      "buutti" = {id = "WSCI2BT-CE75BLT-RLRMHDO-SARY35B-I7KGQ4I-2U6S6OP-IWAO6UH-MMOU7Q6";};
    };
  };
}
