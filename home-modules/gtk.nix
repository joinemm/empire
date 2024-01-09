{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      qogir-icon-theme
      dracula-theme
    ];

    pointerCursor = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir";
      size = 24;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  gtk = {
    enable = true;
    theme.name = "Dracula";
    iconTheme.name = "Qogir";
  };
}
