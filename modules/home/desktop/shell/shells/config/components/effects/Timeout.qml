import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.globals

Scope {
  id: root

  // Options
  final readonly property int fadeoutMillis: 1000
  default property alias content: loader.children

  property bool shouldShowOsd: false

  Timer {
    id: hideTimer
    interval: root.fadeoutMillis
    onTriggered: root.shouldShowOsd = false
  }

  // The OSD window will be created and destroyed based on shouldShowOsd.
  // PanelWindow.visible could be set instead of using a loader, but using
  // a loader will reduce the memory overhead when the window isn't open.
  LazyLoader {
    active: root.shouldShowOsd
    id: loader
  }
}
