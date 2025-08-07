import QtQuick
import Quickshell.Hyprland
import QtQuick.Controls
import QtQuick.Layouts
import qs.globals

RowLayout {
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
