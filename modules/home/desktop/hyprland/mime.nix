{ pkgs, lib, ext, ... }:

let
  hyprLib = import ./support/hypr-lib.nix { inherit lib ext; };
  globals = import ./support/hypr-globals.nix { inherit pkgs lib ext hyprLib; };
  mkOkularApp = type: "okularApplication_${type}.desktop";
  libreOffice = builtins.listToAttrs (map 
    (x: {
      name = x;
      value = "${x}.desktop";
    })
    [
      "base"
      "calc"
      "draw"
      "impress"
      "math"
      "startcenter"
      "writer"
    ]
  );
in

{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = ext.lib.attrsets.compressAttrs "/" (with globals.apps; {
    application = {
      json = textEditor.desktop;
      pdf = mkOkularApp "pdf";
      xhtml = web.desktop;
      xml = web.desktop;
      x-extension-htm = web.desktop;
      x-extension-html = web.desktop;
      x-extension-shtml = web.desktop;
      x-extension-xhtml = web.desktop;
      x-extension-xht = web.desktop;
      octet-stream = archiveManager.desktop;
      x-zip-compressed = archiveManager.desktop;
      "x-vnd.oasis.opendocument.text" = libreOffice.writer;
      "vnd.oasis.opendocument.spreadsheet" = libreOffice.calc;
      "vnd.oasis.opendocument.presentation" = libreOffice.impress;
      clarisworks = libreOffice.writer;
      "docbook+xml" = libreOffice.writer;
      macwriteii = libreOffice.writer;
      msword = libreOffice.writer;
      "prs.plucker" = libreOffice.writer;
      rtf = libreOffice.writer;
      "vnd.apple.pages" = libreOffice.writer;
      "vnd.lotus-wordpro" = libreOffice.writer;
      "vnd.ms-word" = libreOffice.writer;
      "vnd.ms-word.document.macroEnabled.12" = libreOffice.writer;
      "vnd.ms-word.template.macroEnabled.12" = libreOffice.writer;
      "vnd.ms-works" = libreOffice.writer;
      "vnd.oasis.opendocument.text" = libreOffice.writer;
      "vnd.oasis.opendocument.text-flat-xml" = libreOffice.writer;
      "vnd.oasis.opendocument.text-master" = libreOffice.writer;
      "vnd.oasis.opendocument.text-master-template" = libreOffice.writer;
      "vnd.oasis.opendocument.text-template" = libreOffice.writer;
      "vnd.oasis.opendocument.text-web" = libreOffice.writer;
      "vnd.openxmlformats-officedocument.wordprocessingml.document" = libreOffice.writer;
      "vnd.openxmlformats-officedocument.wordprocessingml.template" = libreOffice.writer;
      "vnd.palm" = libreOffice.writer;
      "vnd.stardivision.writer-global" = libreOffice.writer;
      "vnd.sun.xml.writer" = libreOffice.writer;
      "vnd.sun.xml.writer.global" = libreOffice.writer;
      "vnd.sun.xml.writer.template" = libreOffice.writer;
      "vnd.wordperfect" = libreOffice.writer;
      wordperfect = libreOffice.writer;
      x-abiword = libreOffice.writer;
      x-aportisdoc = libreOffice.writer;
      x-doc = libreOffice.writer;
      x-extension-txt = libreOffice.writer;
      "x-fictionbook+xml" = libreOffice.writer;
      x-hwp = libreOffice.writer;
      x-iwork-pages-sffpages = libreOffice.writer;
      x-mswrite = libreOffice.writer;
      x-pocket-word = libreOffice.writer;
      x-sony-bbeb = libreOffice.writer;
      x-starwriter = libreOffice.writer;
      x-starwriter-global = libreOffice.writer;
      x-t602 = libreOffice.writer;
    };
    multipart = {
      x-zip = archiveManager.desktop;
    };
    image = (builtins.listToAttrs (map (x: { name = x; value = imageViewer.desktop; }) [
      "bmp"
      "avif"
      "heic"
      "jpeg"
      "jxl"
      "png"
      "svg+xml"
      "svg+xml-compressed"
      "tiff"
      "vnd-ms.dds"
      "vnd.microsoft.icon"
      "vnd.radiance"
      "webp"
      "x-dds"
      "x-exr"
      "x-portable-anymap"
      "x-portable-bitmap"
      "x-portable-graymap"
      "x-portable-pixmap"
      "x-qoi"
      "x-tga"
    ]));
    inode = {
      directory = fileManager.desktop;
    };
    text = {
      html = web.desktop;
      markdown = textEditor.desktop;
      plain = textEditor.desktop;
    };
    video.mp4 = videoPlayer.desktop;
    x-scheme-handler = {
      http = web.desktop;
      https = web.desktop;
      chrome = web.desktop;
      ipfs = web.desktop;
      ipns = web.desktop;
      discord = discord.desktop;
      ror2mm = "r2modman.desktop";
    };
  });
}
