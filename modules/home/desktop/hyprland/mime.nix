{ pkgs, lib, ext, ... }:

let
  hyprLib = import ./support/hypr-lib.nix { inherit lib ext; };
  globals = import ./support/hypr-globals.nix { inherit pkgs lib ext hyprLib; };
  mkOkularApp = type: "okularApplication_${type}.desktop";
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
