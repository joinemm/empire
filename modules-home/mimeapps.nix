{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        file-manager = "pcmanfm.desktop";
        editor = "nvim.desktop";
        browser = "firefox.desktop";
        video-player = "mpv.desktop";
        image-viewer = "imv-dir.desktop";
      in {
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "image/gif" = [image-viewer];
        "image/jpeg" = [image-viewer];
        "image/png" = [image-viewer];
        "image/webp" = [image-viewer];
        "inode/directory" = [file-manager];
        "text/csv" = [editor];
        "text/html" = [browser];
        "text/plain" = [editor];
        "video/mp4" = [video-player];
        "video/webm" = [video-player];
        "video/x-matroska" = [video-player];
        "x-scheme-handler/http" = [browser];
        "x-scheme-handler/https" = [browser];
        "x-scheme-handler/chrome" = [browser];
        "application/x-extension-htm" = [browser];
        "application/x-extension-html" = [browser];
        "application/x-extension-shtml" = [browser];
        "application/xhtml+xml" = [browser];
        "application/x-extension-xhtml" = [browser];
        "application/x-extension-xht" = [browser];
      };
    };
  };
}
