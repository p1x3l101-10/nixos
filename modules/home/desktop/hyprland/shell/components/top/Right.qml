import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
  anchors {
    right: parent.right
    rightMargin: 8
  }
  SystemClock { id: sysClock }

  Label {
    id: clock
    readonly property string time: {
      Qt.formatDateTime(sysClock.date, "h:mm:ss ap")
    }
  
    anchors.right:parent.right
    text: time
    color: Theme.base05
  }
}
