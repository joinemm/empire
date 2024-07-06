{
  user,
  pkgs,
  lib,
  ...
}: {
  security.sudo.wheelNeedsPassword = false;
  # use bash for headless systems
  users.users.${user.name}.shell = lib.mkForce pkgs.bashInteractive;
  programs.zsh.enable = lib.mkForce false;
}
