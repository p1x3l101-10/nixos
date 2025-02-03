# DO NOT CALL ON THIS FILE DIRECTLY
{ cfg
, extra ? { }
, ...
}:

{
  xdg.mimeApps = {
    enable = true; # mkForce does 50, force the force!
    defaultApplications = {
      "text/plain" = [ cfg.text ];
      "text/x-markdown" = [ cfg.text ];
      "text/html" = [ cfg.web ];

      "text/x-csharp" = [ cfg.ide ];
      "text/x-c" = [ cfg.ide ];
      "text/x-csrc" = [ cfg.ide ];
      "text/x-changelog" = [ cfg.ide ];
      "text/x-chdr" = [ cfg.ide ];
      "text/x-c++" = [ cfg.ide ];
      "text/x-python" = [ cfg.ide ];
      "text/x-go" = [ cfg.ide ];
      "text/x-xml" = [ cfg.ide ];
      "text/x-sql" = [ cfg.ide ];
      "text/x-ruby" = [ cfg.ide ];
      "text/x-pkg-config" = [ cfg.ide ];
      "text/x-lua" = [ cfg.ide ];
      "text/x-php" = [ cfg.ide ];
      "text/x-php-source" = [ cfg.ide ];
      "text/x-perl" = [ cfg.ide ];
      "text/x-javascript" = [ cfg.ide ];
      "text/javascript" = [ cfg.ide ];
      "text/x-js" = [ cfg.ide ];
      "text/x-shellscript" = [ cfg.ide ];
      "text/x-sh" = [ cfg.ide ];
      "text/x-vala" = [ cfg.ide ];
      "text/x-makefile" = [ cfg.ide ];
      "text/x-cpp" = [ cfg.ide ];
      "text/x-c++src" = [ cfg.ide ];
      "text/x-css" = [ cfg.ide ];

      "application/x-python" = [ cfg.ide ];
      "application/javascript" = [ cfg.ide ];
      "application/x-javascript" = [ cfg.ide ];
      "application/x-shellscript" = [ cfg.ide ];
      "application/x-gnome-app" = [ cfg.ide ];
      "application/x-desktop" = [ cfg.ide ];
      "application/x-m4" = [ cfg.ide ];
      "application/x-xml" = [ cfg.ide ];
      "application/x-yaml" = [ cfg.ide ];
      "application/x-ruby" = [ cfg.ide ];
      "application/x-php" = [ cfg.ide ];
      "application/x-php-source" = [ cfg.ide ];
      "application/x-perl" = [ cfg.ide ];

      "x-scheme-handler/sms" = [ cfg.kdeConnect ];
      "x-scheme-handler/tel" = [ cfg.kdeConnect ];
      "x-scheme-handler/http" = [ cfg.web ];
      "x-scheme-handler/https" = [ cfg.web ];

      "application/zip" = [ cfg.archiver ];
      "application/xhtml+xml" = [ cfg.web ];
      "application/pdf" = [ cfg.pdfReader ];

      "image/jpeg" = [ cfg.image ];
      "image/png" = [ cfg.image ];
      "image/gif" = [ cfg.image ];
      "image/webp" = [ cfg.image ];
      "image/tiff" = [ cfg.image ];
      "image/x-tga" = [ cfg.image ];
      "image/vnd-ms" = [ cfg.image ];
      "image/x-dds" = [ cfg.image ];
      "image/bmp" = [ cfg.image ];
      "image/vnd.microsoft.icon" = [ cfg.image ];
      "image/x-exr" = [ cfg.image ];
      "image/x-portable-bitmap" = [ cfg.image ];
      "image/x-portable-graymap" = [ cfg.image ];
      "image/x-portable-pixmap" = [ cfg.image ];
      "image/x-portable-anymap" = [ cfg.image ];
      "image/x-qoi" = [ cfg.image ];
      "image/svg+xml" = [ cfg.image ];
      "image/svg+xml-compressed" = [ cfg.image ];
      "image/avif" = [ cfg.image ];
      "image/heic" = [ cfg.image ];
      "image/jxl" = [ cfg.image ];

      "video/mp4" = [ cfg.video ];
      "video/m4a" = [ cfg.video ];
      "video/mov" = [ cfg.video ];

      "application/x-msdownload" = [ cfg.windows ];

      "x-scheme-handler/mailto" = [ cfg.email ];
      "message/rfc822" = [ cfg.email ];
      "application/mbox" = [ cfg.email ];

      "text/calendar" = [ cfg.calendar ];
      "x-scheme-handler/webcal" = [ cfg.calendar ];

      "text/x-vcard" = [ cfg.contacts ];

      # Hard-coded
      "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
    } // extra;
    associations = {
      added = {
        # GSConnect keeps adding assosiations, this breaks hm
        "x-scheme-handler/sms" = [ cfg.kdeConnect ];
        "x-scheme-handler/tel" = [ cfg.kdeConnect ];
      };
      removed = { };
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
