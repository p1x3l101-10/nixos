import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
  Component.onCompleted: {
    Theme.loadFromJson("/etc/stylix/palette.json");
  }
  Pipewire {}
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
          RowLayout {
            id: right
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
          RowLayout {
            id: center
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
          RowLayout {
            id: left
            anchors {
              left: parent.left
              leftMargin: 8
            }
            Label {
              id: workspace
              anchors.left: parent.left
              readonly property int workspaceId: {
                Hyprland.focusedMonitor.activeWorkspace.id
              }
              text: "Workspace: " + workspaceId
              color: Theme.base05
            }
          }
        }
      }
    }
  }
  Scope {
    id: launcher
    Process {
      property string desktopName: ""
      id: launcherProc
      running: false
      command: ["app2unit", "-s", "a", "--", `${desktopName}.desktop`]
    }
    IpcHandler {
      target: "launch"

      function desktop(desktopName: string):void {
        launcherProc.desktopName = desktopName;
        console.info("started");
        launcherProc.startDetached();
        return;
     }
    }
  }
}
