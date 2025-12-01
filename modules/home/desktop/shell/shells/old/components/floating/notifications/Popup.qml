//@ pragma Internal
import qs.globals
import Quickshell
import Quickshell.Services.Notifications

Scope {
  id: root 
  Server.notifications
  property bool shouldShowOsd: false
  Timer {
    id: hideTimer
    interval: 30 * 1000
    onTriggered: root.shouldShowOsd = false
    running: false
  }
  function newNotif() {
    shouldShowOsd = true;
  }
  Component.onCompleted: {
    Server.notifServer.notification.connect(newNotif)
  }
  LazyLoader {
    active: root.shouldShowOsd
  }
}
