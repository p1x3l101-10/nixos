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
      color: Theme.base0D
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
          property string hours: clock.hours.toString().padStart(2, '0')
          property string minutes: clock.minutes.toString().padStart(2, '0')
          property string seconds: clock.seconds.toString().padStart(2, '0')
  
          anchors.centerIn: parent
          text: `${hours}:${minutes}:${seconds}`
          color: Theme.base05
        }
      }
    }
  }
}
