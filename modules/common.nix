{
  pkgs,
  user,
  lib,
  inputs,
  ...
}:
{
  # disable beeping motherboard speaker
  boot.blacklistedKernelModules = [ "pcspkr" ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment.variables = {
    GOPATH = "${user.home}/.local/share/go";
  };

  zramSwap.enable = true;

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  console = {
    font = "ter-v24b";
    packages = [ pkgs.terminus_font ];
  };

  security = {
    polkit = {
      enable = true;

      # allow me to use systemd without password every time
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
            subject.user == "${user.name}") {
            return polkit.Result.YES;
          }
        });
      '';
    };

    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults passwd_timeout=0
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    package = pkgs.nixVersions.latest;

    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      allow-import-from-derivation = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;

      # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
      max-substitution-jobs = 128;
      http-connections = 128;
      max-jobs = "auto";
    };
  };

  users.users."${user.name}" = {
    isNormalUser = true;
    description = user.fullName;
    extraGroups = [ "wheel" ];
  };

  environment = {
    shells = [
      pkgs.bashInteractive
      pkgs.fish
    ];

    # uninstall all default packages that I don't need
    defaultPackages = lib.mkForce [ ];

    systemPackages = with pkgs; [
      git
      vim
      wget
      neofetch
      pciutils
      usbutils
      dig
    ];
  };
}
