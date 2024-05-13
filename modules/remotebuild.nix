{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "hetzarm";
        system = "aarch64-linux";
        maxJobs = 80;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        sshUser = "jrautiola";
        sshKey = "/home/joonas/.ssh/id_ed25519";
      }
    ];
  };

  programs.ssh = {
    extraConfig = ''
      Host hetzarm
        HostName 65.21.20.242
    '';
    knownHosts = {
      "65.21.20.242".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx4zU4gIkTY/1oKEOkf9gTJChdx/jR3lDgZ7p/c7LEK";
    };
  };
}
