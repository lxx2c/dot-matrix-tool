import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

Item {
    property string dm_name: ""
    property int dm_font_size: 15
    property int dm_max_length: 10
    property string dm_input_value: ""
    property string dm_current_value: ""

    // 不允许使用的文件名字符
    property string illegalChars: "\\/:.*?\"<>|"

    id: _root
    Row {
        id: _row
        spacing: 5
        Text {
            id: _text
            font.pixelSize: dm_font_size
            text: qsTr(dm_name)
            anchors.verticalCenter: parent.verticalCenter
        }

        TextField {
            id: _input_value
            text: dm_input_value
            width: _root.width - _text.width - _row.spacing
            height: _text.height + 12
            selectByMouse: true
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            background: Rectangle {
                implicitHeight: _root.height
                border.width: 0.5
                radius: 2
            }
            maximumLength: dm_max_length
            font.pixelSize: _text.font.pixelSize - 2
            onTextChanged: {
                for (var i = 0; i < _input_value.text.length; i++) {
                    if (illegalChars.indexOf(_input_value.text[i]) !== -1) {
                        var newText = _input_value.text.slice(
                                    0, i) + _input_value.text.slice(i + 1)
                        _input_value.text = newText
                    }
                }
                _root.dm_current_value = _input_value.text
            }
        }
    }
}
