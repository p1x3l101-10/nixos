import Quickshell
import Quickshell.Services.Pipewire
import qs.components.floating

Scope {
  // Bind to pipewire
  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ]
  }
  Connections {
    target: Pipewire.defaultAudioSink?.audio

    function onVolumeChanged() {
      root.shouldShowOsd = true;
      root.restartTimer();
    }
  }
  FloatingFadeoutSlider {
    id: root
    fillPercent: (Pipewire.defaultAudioSink?.audio.volume ?? 0)
    icon: Quickshell.iconPath("audio-volume-high-symbolic")
  }
}