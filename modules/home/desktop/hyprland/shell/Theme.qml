// Theme.qml
pragma Singleton
import QtQuick 2.15

QtObject {
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

  function loadFromJson(jsonPath) {
    let xhr = new XMLHttpRequest();
    xhr.open("GET", jsonPath);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
          let raw = JSON.parse(xhr.responseText);
          for (let key in raw) {
            if (raw.hasOwnProperty(key) && key.startsWith("base")) {
              Theme[key] = "#" + raw[key];
            }
          }
        } else {
          console.warn("Failed to load palette:", xhr.status);
        }
      }
    }
    xhr.send();
  }
}

