//@ pragma Internal
pragma singleton
import Quickshell.Services.Notifications
import Quickshell

Singleton {
  id: server
  property alias notifications: notifServer.trackedNotifications
  NotificationServer {
    id: notifServer
    imageSupported: false
    keepOnReload: false
    bodyHyperlinksSupported: false
    bodyImagesSupported: false
    bodyMarkupSupported: true
    bodySupported: true
    actionsSupported: false
    inlineReplySupported: false
    persistanceSupported: false
    actionIconsSupported: false
  }
}
