{
  pkgs,
  user,
  ...
}: {
  # disable beeping motherboard speaker
  boot.blacklistedKernelModules = ["pcspkr"];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  console = {
    font = "ter-v24b";
    packages = [pkgs.terminus_font];
  };

  security = {
    polkit.enable = true;

    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults passwd_timeout=0
      '';
    };
  };

  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    trusted-users = ["root" "@wheel"];
    experimental-features = ["nix-command" "flakes"];

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

  users.users."${user.name}" = {
    isNormalUser = true;
    description = user.fullName;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.variables = {
    GOPATH = "${user.home}/.local/share/go";
  };

  environment = {
    # fix completion for zsh
    pathsToLink = ["/share/zsh"];
    # allow both zsh and bash
    shells = [pkgs.bashInteractive pkgs.zsh];

    systemPackages = with pkgs; [
      git
      vim
      neofetch
      file
      bottom
      jq
      dig
      wget
    ];
  };
}
