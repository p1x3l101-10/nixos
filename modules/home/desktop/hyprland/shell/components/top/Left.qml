import QtQuick
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
  Layout.alignment: Qt.AlignLeft
  Layout.leftMargin: 8
  Layout.fillWidth: true
  Label {
    id: workspace
    readonly property int workspaceId: {
      Hyprland.focusedMonitor.activeWorkspace.id
    }
    text: "Workspace: " + workspaceId
    color: Theme.base05
  }
}
