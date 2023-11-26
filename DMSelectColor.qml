import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2

Item {
    property string dm_name: ""
    property int dm_size: 15
    property int dm_font_size: 15
    property string dm_input_value: "green"
    property string dm_current_value: "green"
    id: _root

    implicitHeight: 30
    implicitWidth: 100

    ColorDialog {
        id: _color_dialog
        currentColor: dm_input_value
        onCurrentColorChanged: {
            dm_current_value = currentColor
        }
    }

    Row {
        id: _row
        spacing: 5
        Text {
            id: _text
            font.pixelSize: dm_font_size
            text: qsTr(dm_name)
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle {
            width: dm_size
            height: dm_size
            border.color: "black"
            border.width: 1
            color: dm_current_value
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    _color_dialog.open()
                }
            }
        }
    }
}
