import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property string dm_name: ""
    property int dm_font_size: 15
    property var dm_model: []
    property int dm_input_value: 0
    property int dm_current_value: 0
    id: _root

    implicitHeight: 30
    implicitWidth: 100

    Row {
        id: _row
        spacing: 5
        Text {
            id: _text
            font.pixelSize: dm_font_size
            text: qsTr(dm_name)
            anchors.verticalCenter: parent.verticalCenter
        }
        ComboBox {
            id: _combo
            currentIndex: dm_input_value
            width: _root.width - _text.width - 5
            height: _root.height - 8
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {

                color: "#E0E0E0"
                radius: 3
            }
            indicator: Rectangle {
                width: 5
                height: parent.height
                color: "green"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }

            contentItem: Text {
                text: _combo.displayText
                font.pixelSize: dm_font_size
                verticalAlignment: Text.AlignVCenter
                leftPadding: 1
            }

            model: dm_model
            onCurrentIndexChanged: {
                dm_current_value = currentIndex
            }
        }
    }
}
