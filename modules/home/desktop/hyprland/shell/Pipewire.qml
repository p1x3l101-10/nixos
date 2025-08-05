import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
	id: root

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	// The OSD window will be created and destroyed based on shouldShowOsd.
	// PanelWindow.visible could be set instead of using a loader, but using
	// a loader will reduce the memory overhead when the window isn't open.
	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			// Since the panel's screen is unset, it will be picked by the compositor
			// when the window is created. Most compositors pick the current active monitor.

			anchors.bottom: true
			margins.bottom: screen.height / 5
			exclusiveZone: 0

			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}
      
      Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.base0D
			  Rectangle {
          anchors {
            fill: parent
            topMargin: 2
            bottomMargin: 2
            leftMargin: 2
            rightMargin: 2
          }
				  radius: height / 2
				  color: Theme.base00
  
				  RowLayout {
					  anchors {
						  fill: parent
						  leftMargin: 10
						  rightMargin: 15
              topMargin: -2
					  }
  
            Text {
              font {
                family: "Sauce Code Pro"
                pointSize: 30
              }
              text: "󰕾"
              color: Theme.base05
            }

					  Rectangle {
						  // Stretches to fill all left-over space
						  Layout.fillWidth: true
  
						  implicitHeight: 10
						  radius: 20
						  color: Theme.base01
  
						  Rectangle {
							  anchors {
								  left: parent.left
								  top: parent.top
								  bottom: parent.bottom
							  }

							  implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
							  radius: parent.radius
						  }
					  }
				  }
			  }
		  }
    }
  }
}
