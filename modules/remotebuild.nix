{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "hetzarm.vedenemo.dev";
        system = "aarch64-linux";
        maxJobs = 20;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        sshUser = "jrautiola";
        sshKey = "/home/joonas/.ssh/id_ed25519";
      }
      {
        hostName = "builder.vedenemo.dev";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        sshUser = "jrautiola";
        sshKey = "/home/joonas/.ssh/id_ed25519";
      }
    ];
  };

  programs.ssh.knownHosts = {
    "hetzarm.vedenemo.dev".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx4zU4gIkTY/1oKEOkf9gTJChdx/jR3lDgZ7p/c7LEK";
    "builder.vedenemo.dev".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSI8s/wefXiD2h3I3mIRdK+d9yDGMn0qS5fpKDnSGqj";
  };
}
