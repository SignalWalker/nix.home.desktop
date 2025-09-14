import QtQuick
import qs.utils
import Quickshell.Wayland
import Quickshell.Widgets

Column {
	Repeater {
		component AppItem : Column {
			id: root
			required property Toplevel modelData
			IconImage {
				source: Icons.getAppIcon(root.modelData.appId, "undefined")
				implicitWidth: 32
				implicitHeight: 32
			}
			Text {
				text: root.modelData.title
			}
		}
		model: ToplevelManager.toplevels
		delegate: AppItem {}
	}
}
