{
  inputs,
  user,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  environment.extraInit =
    let
      homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
    in
    "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

  home-manager = {
    extraSpecialArgs = {
      inherit user inputs;
    };
    users."${user.name}" =
      let
        homeModules = import ../home-modules;
      in
      {
        imports = lib.flatten [ homeModules.default-modules ];
      };
  };
}
