//@ pragma Internal
import QtQuick
import Quickshell
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
  Layout.alignment: Qt.AlignRight
  Layout.rightMargin: 8
  Layout.fillWidth: true
  SystemClock { id: sysClock }

  Label {
    id: clock
    readonly property string time: {
      Qt.formatDateTime(sysClock.date, "h:mm:ss ap")
    }
  
    text: time
    color: Theme.base05
  }
}
