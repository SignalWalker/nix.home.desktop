pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, "hh\nmm")
  }

  readonly property SystemClock clock: SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
