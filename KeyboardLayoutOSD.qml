import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

DankOSD {
    id: root

    osdWidth: 180
    osdHeight: 40
    autoHideInterval: 1000
    enableMouseInteraction: false

    property string currentLayout: ""

    function updateLayout(layoutName) {
        root.currentLayout = layoutName;
        root.show();
    }

    content: Item {
        anchors.fill: parent

        Rectangle {
            anchors.centerIn: parent
            width: parent.width - Theme.spacingS * 2
            height: parent.height - Theme.spacingS * 2
            color: "transparent"
            radius: Theme.cornerRadius

            Row {
                anchors.centerIn: parent
                spacing: Theme.spacingS

                DankIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    name: "keyboard"
                    size: Theme.iconSize
                    color: Theme.primary
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.currentLayout
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                }
            }
        }
    }
}