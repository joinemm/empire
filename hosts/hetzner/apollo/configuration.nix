{
  lib,
  inputs,
  modules,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with modules; [
      common
      hetzner
      docker
      nginx
      ssh-access
      syncthing
    ])
    inputs.disko.nixosModules.disko
    ../disk-root.nix
    (import ../disk-block-storage.nix {
      id = "100958858";
      mountpoint = "/data";
    })
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "apollo";

  environment.systemPackages = with pkgs; [
    busybox
  ];

  # services.plausible = {
  #   enable = true;
  #   server.baseUrl = "https://traffic.joinemm.dev";
  # };

  services.syncthing = {
    dataDir = "/mnt/volume/sync";
    settings.folders = {
      "camera".enable = true;
      "code".enable = true;
      "documents".enable = true;
      "mobile-downloads".enable = true;
      "mobile-screenshots".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "videos".enable = true;
      "work".enable = true;
    };
  };

  services.nginx.virtualHosts = let
    baseDomain = "joinemm.dev";
    mkRedirect = to: {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        return = "302 ${to}";
      };
    };
  in {
    "git.${baseDomain}" = {
      enableACME = true;
      forceSSL = true;
      locations."~ (?<repo>[^/\\s]+)" = {
        return = "301 https://github.com/joinemm/$repo";
      };
    };

    "traffic.${baseDomain}" = {
      enableACME = true;
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

    "sync.${baseDomain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
      };
    };

    # "cdn.joinemm.dev" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:8055";
    #   };
    #   extraConfig = "client_max_body_size 100M;";
    # };

    "digitalocean.${baseDomain}" = mkRedirect "https://m.do.co/c/7251aebbc5e0";

    "vultr.${baseDomain}" = mkRedirect "https://vultr.com/?ref=8569244-6G";

    "hetzner.${baseDomain}" = mkRedirect "https://hetzner.cloud/?ref=JkprBlQwg9Kp";
  };

  system.stateVersion = "24.05";
}
