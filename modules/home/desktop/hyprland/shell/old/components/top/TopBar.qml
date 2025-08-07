import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.globals

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
      RowLayout {
        anchors.fill: parent
        Left {}
        Center {}
        Right {}
      }
    }
  }
}
