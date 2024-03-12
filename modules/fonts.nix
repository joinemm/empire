{pkgs, ...}: {
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = ["Twitter Color Emoji"];
        monospace = ["Fira Code Nerd Font" "Sarasa Gothic"];
        sansSerif = ["Cantarell" "Sarasa Gothic"];
      };

      hinting.style = "full";
      subpixel.rgba = "rgb";
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode"];})
      cantarell-fonts
      twitter-color-emoji
      sarasa-gothic
    ];
  };
}
