import QtQuick
import qs.Common
import qs.Services
import qs.Widgets

DankOSD {
    id: root

    property string currentLayout: ""

    function updateLayout(layoutName) {
        root.currentLayout = layoutName;
        root.show();
    }

    animationDuration: 120
    autoHideInterval: 650
    enableMouseInteraction: false
    osdHeight: 40
    osdWidth: 180

    content: Item {
        anchors.fill: parent

        Rectangle {
            anchors.centerIn: parent
            color: "transparent"
            height: parent.height - Theme.spacingS * 2
            radius: Theme.cornerRadius
            width: parent.width - Theme.spacingS * 2

            Row {
                anchors.centerIn: parent
                spacing: Theme.spacingS

                DankIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.primary
                    name: "keyboard"
                    size: Theme.iconSize
                }
                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.surfaceText
                    font.pixelSize: Theme.fontSizeLarge
                    font.weight: Font.Medium
                    text: root.currentLayout
                }
            }
        }
    }
}
