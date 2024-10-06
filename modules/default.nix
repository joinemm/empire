{
  flake.nixosModules = {
    attic = ./attic.nix;
    bluetooth = ./bluetooth.nix;
    common = ./common.nix;
    desktop = ./desktop;
    docker = ./docker.nix;
    gaming = ./gaming.nix;
    home = ./home.nix;
    headless = ./headless.nix;
    hetzner = ./hetzner.nix;
    keyd = ./keyd.nix;
    laptop = ./laptop.nix;
    locale = ./locale.nix;
    nginx = ./nginx.nix;
    node-exporter = ./node-exporter.nix;
    remotebuild = ./remotebuild.nix;
    ssh-access = ./ssh-access.nix;
    syncthing = ./syncthing.nix;
    tailscale = ./tailscale.nix;
    transmission = ./transmission.nix;
    virtualization = ./virtualization.nix;
    work = ./work.nix;
    yubikey = ./yubikey.nix;
  };
}
