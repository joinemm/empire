{
  config,
  pkgs,
  ...
}: let
  user = "joonas";
  publicKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdrlMsN+yqst4ThORcm9Jf2g5JNVWcjIkzkRow8BCChZjC/EqbVCAeN8LfdGniefre49KNc40IxJENnrtu3TitFHDBhuRYrFJ1csK6dD1pZBeFrCPrWjr7b1e9PwusQddI7Xi/amSf8XlmBvDMXRnvqFnBD4xNdmd5DMPDi2Q5FjzNqlsuEAPPegahb0OoGIYGbwUfHtVDtUtuN6oYUYuQbiz92Fjpy5tyz/Bb4Wrw7iphL5nITM0l/BdtGFv4D/UUa3cju74xIm5Qi93qBaNXhQwRVv1c2pzBQvwQltjQYxV9kvTcG24cI+iS/XUaalKV539q/wXaC9h5aKEYyMn+TzuATZsvcP45JQeZpkMcOsCCKroIvOzeizfYbIW7+T5rdhkC0PFfmo1/WYQ4fcbukgEBa3OjuG8LGZvHo7BLj46s+qW3dV+WemhIHiFXYI9sTaXzL4pxgXI1DwYaz1tSMOQTOh+rYqjhUaaqsQqLdbcdBlrpInIvZqpC3VUkTyU= join@cerberus"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6EoeiMBiiwfGJfQYyuBKg8rDpswX0qh194DUQqUotL joonas@buutti"
  ];
  syncDir = "/sync";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/sda";
  };

  networking = {
    hostName = "oolacile";
    nameservers = ["1.1.1.1"];
    firewall.enable = true;
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "ens3";
      networkConfig.DHCP = "ipv4";
    };
  };

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-v32n";
    packages = with pkgs; [terminus_font];
  };

  users = {
    users = {
      ${user} = {
        isNormalUser = true;
        extraGroups = ["wheel" "docker"];
        openssh.authorizedKeys.keys = publicKeys;
        initialPassword = "asdf";
      };
      root = {
        initialHashedPassword = "";
        openssh.authorizedKeys.keys = publicKeys;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];

  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  services.syncthing = {
    enable = true;
    dataDir = "${syncDir}";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "0.0.0.0:8000";
    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
        "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
        "windows" = {id = "3D3Z5N4-JLIWTGO-IJFSPLG-VWEJNH6-WLQDBMH-UCIMAWB-ONWDSP6-7NCL7AU";};
        "unikie" = {id = "J4ASID7-BTVUC22-MMVY2GJ-A6YIMQI-PMBRV7S-FIN7OTV-PNPCV62-6GY7AAF";};
        "buutti" = {id = "WSCI2BT-CE75BLT-RLRMHDO-SARY35B-I7KGQ4I-2U6S6OP-IWAO6UH-MMOU7Q6";};
      };
      folders = {
        "camera" = {
          path = "${syncDir}/camera";
          id = "25yyh-212sq";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "code" = {
          path = "${syncDir}/code";
          id = "asqhs-gxzl4";
          devices = ["andromeda" "cerberus" "buutti"];
        };
        "documents" = {
          path = "${syncDir}/documents";
          id = "rg3sy-y9Wvv";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-downloads" = {
          path = "${syncDir}/mobile-downloads";
          id = "m7oev-edqfh";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-screenshots" = {
          path = "${syncDir}/mobile-screenshots";
          id = "6517n-x3hlt";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "notes" = {
          path = "${syncDir}/notes";
          id = "jmdvx-nzh9p";
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
        };
        "pictures" = {
          path = "${syncDir}/pictures";
          id = "zuaps-ign9t";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "videos" = {
          path = "${syncDir}/videos";
          id = "hmrxy-xkgrb";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "work" = {
          path = "${syncDir}/work";
          id = "meugk-eipcy";
          ignorePerms = false; # perms are ignored by default
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "joonas@rautiola.co";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "test.joinemm.dev" = {
        enableACME = true;
        addSSL = true;
        forceSSL = true;
        locations."~ (.*)" = {
          return = "301 https://github.com/joinemm/$1";
        };
      };
      "testier.joinemm.dev" = {
        enableACME = true;
        addSSL = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
        };
        locations."/visit.js" = {
          proxyPass = "http://127.0.0.1:8000/js/script.outbound-links.js";
          extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
        };
      };
    };
  };
}
