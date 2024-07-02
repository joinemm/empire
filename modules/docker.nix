{user, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  users.users."${user.name}".extraGroups = ["docker"];
}
