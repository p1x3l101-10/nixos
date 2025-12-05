//@ pragma Internal
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
  Layout.alignment: Qt.AlignHCenter
  Layout.fillWidth: true
  Label {
    id: windowName
    function appNameFiltered() {
      return Hyprland.activeToplevel !== null ? Hyprland.activeToplevel.title : ""
    }
    text: appNameFiltered()
    color: Theme.base05
  }
}
