import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Controls

Frame {
	Column {
		Repeater {
			component WorkspaceItem : Text {
				id: root
				required property HyprlandWorkspace modelData
				anchors.horizontalCenter: parent.horizontalCenter
				text: root.modelData.name
			}
			model: ScriptModel {
				values: Hyprland.workspaces.values.filter(ws => ws.id >= 0)
			}
			delegate: WorkspaceItem {}
		}
	}
}
