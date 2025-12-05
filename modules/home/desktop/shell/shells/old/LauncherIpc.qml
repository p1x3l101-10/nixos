import Quickshell
import Quickshell.Io

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
