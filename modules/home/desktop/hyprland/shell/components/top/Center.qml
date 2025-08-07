import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
  anchors.centerIn: parent
  Label {
    id: windowName
    anchors.centerIn: parent
    function appNameFiltered() {
      return Hyprland.activeToplevel !== null ? Hyprland.activeToplevel.title : ""
    }
    text: appNameFiltered()
    color: Theme.base05
  }
}
