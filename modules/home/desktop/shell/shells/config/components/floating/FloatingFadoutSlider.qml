import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.globals
import qs.components.floating
import qs.components.effects

Timeout {
  id: timeout
  final readonly required property alias icon: icon.source
  property real fillPercent: 0
  fadeoutMillis: 1000
  FloatingBase {
    id: floater
    RowLayout {
      anchors: {
        fill: parent
        leftMargin: 10
        rightMargin: 15
        topMargin: -2
      }
      IconImage: {
        id: icon
        implicitSize: 30
      }
      Rectangle {
        Layout.fillWidth: true
        implicitHieght: 10
        radius: 20
        color: Theme.base01
        Rectangle {
          anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
          }
          radius: parent.radius
          implicitWidth: parent.width * root.fillPercent
        }
      }
    }
  }
}
