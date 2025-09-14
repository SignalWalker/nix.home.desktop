import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        right: true
        bottom: true
      }

      implicitWidth: 32

      Column {
        id: start

        anchors {
          left: parent.left
          right: parent.right
          top: parent.top
        }

        ClockWidget {
          anchors.horizontalCenter: parent.horizontalCenter
        }

        WorkspaceList {
		      anchors.horizontalCenter: parent.horizontalCenter
        }
      }

      Column {
        id: middle
        anchors {
          left: parent.left
          right: parent.right
          verticalCenter: parent.verticalCenter
        }
      }

      Column {
        id: end
        anchors {
          left: parent.left
          right: parent.right
          bottom: parent.bottom
        }

        Tray {
          anchors.fill: parent
        }
      }
    }
  }
}
