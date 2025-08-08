pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property color background:                 Base16Theme.base01
  readonly property color error:                      Base16Theme.base08
  readonly property color error_container:            Base16Theme.base0D
  readonly property color inverse_on_surface:         Base16Theme.base05
  readonly property color inverse_primary:            Base16Theme.base08
  readonly property color inverse_surface:            Base16Theme.base0E
  readonly property color on_background:              Base16Theme.base05
  readonly property color on_error:                   Base16Theme.base08
  readonly property color on_error_container:         Base16Theme.base0A
  readonly property color on_primary:                 Base16Theme.base05
  readonly property color on_primary_container:       Base16Theme.base05
  readonly property color on_primary_fixed:           Base16Theme.base05
  readonly property color on_primary_fixed_variant:   Base16Theme.base0E
  readonly property color on_secondary:               Base16Theme.base05
  readonly property color on_secondary_container:     Base16Theme.base0E
  readonly property color on_secondary_fixed:         Base16Theme.base0E
  readonly property color on_secondary_fixed_variant: Base16Theme.base0E
  readonly property color on_surface:                 Base16Theme.base05
  readonly property color on_surface_variant:         Base16Theme.base0E
  readonly property color on_tertiary:                Base16Theme.base05
  readonly property color on_tertiary_container:      Base16Theme.base0E
  readonly property color on_tertiary_fixed:          Base16Theme.base0E
  readonly property color on_tertiary_fixed_variant:  Base16Theme.base0E
  readonly property color outline:                    Base16Theme.base0E
  readonly property color outline_variant:            Base16Theme.base0E
  readonly property color primary:                    Base16Theme.base08
  readonly property color primary_container:          Base16Theme.base00
  readonly property color primary_fixed:              Base16Theme.base0E
  readonly property color primary_fixed_dim:          Base16Theme.base0E
  readonly property color scrim:                      Base16Theme.base0E
  readonly property color secondary:                  Base16Theme.base09
  readonly property color secondary_container:        Base16Theme.base0E
  readonly property color secondary_fixed:            Base16Theme.base0E
  readonly property color secondary_fixed_dim:        Base16Theme.base0E
  readonly property color shadow:                     Base16Theme.base0E
  readonly property color surface:                    Base16Theme.base00
  readonly property color surface_bright:             Base16Theme.base02
  readonly property color surface_container:          Base16Theme.base01
  readonly property color surface_container_high:     Base16Theme.base03
  readonly property color surface_container_highest:  Base16Theme.base0E
  readonly property color surface_container_low:      Base16Theme.base02
  readonly property color surface_container_lowest:   Base16Theme.base0E
  readonly property color surface_dim:                Base16Theme.base0E
  readonly property color surface_tint:               Base16Theme.base0E
  readonly property color tertiary:                   Base16Theme.base0A
  readonly property color tertiary_container:         Base16Theme.base00
  readonly property color tertiary_fixed:             Base16Theme.base0E
  readonly property color tertiary_fixed_dim:         Base16Theme.base0E

  function withAlpha(color: color, alpha: real): color {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }
}
