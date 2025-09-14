import qs.utils
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

Column {
	Repeater {
		component TrayItem : MouseArea {
			id: root
			required property SystemTrayItem modelData
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			implicitWidth: 16
			implicitHeight: 16
			onClicked: event => {
				if (event.button === Qt.LeftButton) {
					modelData.activate();
				} else {
					modelData.secondaryActivate();
				}
			}
			IconImage {
				source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
				anchors.fill: parent
			}
		}
		model: SystemTray.items
		delegate: TrayItem {}
	}
}
