{pkgs, ...}: {
  config.nixpkgs.overlays = [
    (import ../overlays/xsecurelock.nix {inherit pkgs;})
  ];

  config.systemd.user.services.xss-lock = {
    unitConfig = {
      Description = "Screenlocker service";
      PartOf = ["graphical-session.target"];
    };
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Environment = [
        "XSECURELOCK_COMPOSITE_OBSCURER=0"
        "XSECURELOCK_PASSWORD_PROMPT=asterisks"
        "XSECURELOCK_SHOW_HOSTNAME=0"
        "XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0"
      ];
      ExecStart = "${pkgs.xss-lock}/bin/xss-lock --session \${XDG_SESSION_ID} -- ${pkgs.xsecurelock}/bin/xsecurelock";
    };
  };
}
