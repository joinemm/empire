{ pkgs, user, ... }:
{
  services.udev.packages = [ pkgs.android-udev-rules ];

  environment.variables = {
    GOPATH = "${user.home}/.local/share/go";
  };
}
