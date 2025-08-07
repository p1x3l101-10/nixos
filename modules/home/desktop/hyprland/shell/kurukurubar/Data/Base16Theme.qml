// Theme.qml
pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
  id: themeRoot
  // All base colors, initialized as "#000000"
  property color base00: "#000000"
  property color base01: "#000000"
  property color base02: "#000000"
  property color base03: "#000000"
  property color base04: "#000000"
  property color base05: "#000000"
  property color base06: "#000000"
  property color base07: "#000000"
  property color base08: "#000000"
  property color base09: "#000000"
  property color base0A: "#000000"
  property color base0B: "#000000"
  property color base0C: "#000000"
  property color base0D: "#000000"
  property color base0E: "#000000"
  property color base0F: "#000000"

  FileView {
    id: file
    path: "/etc/stylix/palette.json"
    watchChanges: true
    onFileChanged: parent.reload()
    blockLoading: true
    preload: true
    Component.onCompleted: {
      Base16Theme.reload()
    }
  }
  Component.onCompleted: reload()

  function reload() {
    file.reload();
    let raw = JSON.parse(file.text());
    for (let key in raw) {
      if (raw.hasOwnProperty(key) && key.startsWith("base")) {
        Base16Theme[key] = "#" + raw[key];
      }
    }
  }
}

