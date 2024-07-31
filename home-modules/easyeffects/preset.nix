{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.easyeffects;
in {
  options = {
    services.easyeffects.presets = mkOption {
      type = types.listOf (types.submodule {
        options = {
          device = mkOption {
            type = types.str;
          };
          type = mkOption {
            type = types.enum ["input" "output"];
          };
          profile = mkOption {
            type = types.str;
          };
          file = mkOption {
            type = types.path;
          };
          description = mkOption {
            type = types.str;
            default = "Created by Home Manager";
          };
        };
      });
    };
  };
  config = {
    xdg.configFile = lib.mergeAttrsList (
      map ({
        device,
        type,
        profile,
        file,
        description,
      }: let
        name = builtins.head (lib.splitString "." (builtins.baseNameOf file));
      in {
        "easyeffects/${type}/${name}.json".source = file;
        "easyeffects/autoload/${type}/${device}.json".text =
          builtins.toJSON
          {
            inherit device;
            device-description = description;
            device-profile = profile;
            preset-name = name;
          };
      })
      cfg.presets
    );
  };
}
