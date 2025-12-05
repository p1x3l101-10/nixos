import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.globals

PanelWindow {
  default property alias content: inner.children
  // Since the panel's screen is unset, it will be picked by the compositor
  // when the window is created. Most compositors pick the current active monitor.

  anchors.bottom: true
  margins.bottom: screen.height / 5
  exclusiveZone: 0

  implicitWidth: 400
  implicitHeight: 50
  color: "transparent"

  // An empty click mask prevents the window from blocking mouse events.
  mask: Region {}
  
  Rectangle {
    anchors.fill: parent
    radius: 10
    color: Theme.base0D
    Rectangle {
      anchors {
        fill: parent
        topMargin: 2
        bottomMargin: 2
        leftMargin: 2
        rightMargin: 2
      }
      radius: 9
      color: Theme.base00
      id: inner
    }
  }
}
