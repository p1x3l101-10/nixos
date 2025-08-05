import Quickshell
import QtQuick
import QtQuick.Controls

ShellRoot {
  Component.onCompleted: {
    Theme.loadFromJson("/etc/stylix/palette.json");
  }
  PanelWindow {
    anchors { top: true; left: true; right: true; }
    implicitHeight: 35
    color: "transparent"
    Rectangle {
      anchors {
        fill: parent
        topMargin: 5
        leftMargin: 10
        rightMargin: 10
      }
      color: Theme.base03
      radius: 10
      Rectangle {
        anchors {
          fill: parent
          topMargin: 2
          bottomMargin: 2
          leftMargin: 2
          rightMargin: 2
        }
        color: Theme.base00
        radius: 10

        SystemClock { id: clock }

        Label {
          readonly property string time: {
            Qt.formatDateTime(clock.date, "h:mm:ss ap")
          }
  
          anchors.centerIn: parent
          text: time
          color: Theme.base05
        }
      }
    }
  }
}
