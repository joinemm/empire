{ user, pkgs, ... }:
{
  # use bash for headless systems
  users.users.${user.name}.shell = pkgs.bashInteractive;
}
