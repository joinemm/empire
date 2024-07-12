{
  user,
  pkgs,
  ...
}: {
  security.sudo.wheelNeedsPassword = false;
  # use bash for headless systems
  users.users.${user.name}.shell = pkgs.bashInteractive;
}
