{ config, lib, ... }:

{
  config = import ./mime.cfg.nix {
    cfg = {
      web = "org.gnome.Epiphany.desktop";
      image = "org.gnome.Loupe.desktop";
      video = "org.gnome.Totem.desktop";
      text = "org.gnome.TextEditor.desktop";
      ide = "org.gnome.TextEditor.desktop";
      kdeConnect = "org.gnome.Shell.Extensions.GSConnect.desktop";
      archiver = "org.gnome.FileRoller.desktop";
      pdfReader = "org.gnome.Evince.desktop";
      windows = "bottles.desktop";
      calendar = "org.gnome.Calendar.desktop";
      email = "org.gnome.Geary.desktop";
      contacts = "org.gnome.Contacts.desktop";
    };
    extra = {
      # Add ebook reader
      "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
      "application/x-mobipocket-ebook" = [ "com.github.johnfactotum.Foliate.desktop" ];
    };
  };
}
