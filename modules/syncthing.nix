{
  user,
  config,
  lib,
  ...
}:
{
  services.syncthing = {
    enable = true;

    user = lib.mkDefault user.name;
    dataDir = lib.mkDefault user.home;

    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      # don't submit anonymous usage data
      options.urAccepted = -1;

      devices = {
        "cloud" = {
          id = "UNXBALU-3VLE5GI-2VZBQS7-XFEY3KX-WPVCRQP-55MFDML-CAK27WZ-IGO7HQL";
        };
        "cobalt" = {
          id = "75G5FQ2-4573B6V-CIAQYBB-AFBHADB-CAQVWCW-K3FMRP4-DAENIRD-B35BEQA";
        };
        "carbon" = {
          id = "HQZRDQW-EUEUGNR-M4X3NLQ-KSQXR27-UKTBJIE-GXXVN3K-AW7IW4D-ZHGKXQD";
        };
        "pixel" = {
          id = "7YCKNIE-345NVSB-PV7XBDE-SBACGZA-LTZGLXT-R44IRUF-4RFSJ7P-NRJZXQL";
        };
      };

      folders =
        let
          dir = config.services.syncthing.dataDir;
        in
        {
          "code" = {
            enable = lib.mkDefault false;
            id = "asqhs-gxzl4";
            path = "${dir}/code";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
            ];
            ignorePerms = false;
          };
          "projects" = {
            enable = lib.mkDefault false;
            id = "z6hjs-fj7jy";
            path = "${dir}/projects";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
            ];
          };
          "documents" = {
            enable = lib.mkDefault false;
            id = "rg3sy-y9wvv";
            path = "${dir}/documents";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
              "pixel"
            ];
          };
          "notes" = {
            enable = lib.mkDefault false;
            id = "jmdvx-nzh9p";
            path = "${dir}/notes";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
              "pixel"
            ];
          };
          "pictures" = {
            enable = lib.mkDefault false;
            id = "zuaps-ign9t";
            path = "${dir}/pictures";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
            ];
          };
          "videos" = {
            enable = lib.mkDefault false;
            id = "hmrxy-xkgrb";
            path = "${dir}/videos";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
            ];
          };
          "work" = {
            enable = lib.mkDefault false;
            id = "meugk-eipcy";
            path = "${dir}/work";
            devices = [
              "cloud"
              "cobalt"
              "carbon"
            ];
            ignorePerms = false;
          };
        };
    };
  };
}
