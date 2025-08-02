{ pkgs, lib, ... }:

let
  lib1 = import ./support/hypr-lib.nix lib;
  lib2 = lib.extend (_: _: { hypr = lib1; });
  globals = import ./support/hypr-globals.nix pkgs lib2;
  fixMime = attrs: (lib.foldlAttrs
    (acc: key: value: acc // ({
      "${lib.strings.replaceStrings ["."] ["/"] key}" = value;
    }))
    { }
    attrs);
in

{
  xdg.mime.enable = true;
  xdg.mimeApps.defaultApplications = fixMime (with globals.app; {
    application = {
      json = textEditor.desktop;
      pdf = web.desktop;
      xhtml = web.desktop;
      xml = web.desktop;
      x-extension-htm = web.desktop;
      x-extension-html = web.desktop;
      x-extension-shtml = web.desktop;
      x-extension-xhtml = web.desktop;
      x-extension-xht = web.desktop;
    };
    image = (builtins.listToAttrs (map (x: { name = x; value = imageViewer.desktop; } [
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
    ])));
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
      discord = "vesktop.desktop";
      ror2mm = "r2modman.desktop";
    };
  });
}
