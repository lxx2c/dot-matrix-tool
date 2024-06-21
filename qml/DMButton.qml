import QtQuick 2.0

Rectangle {
    id: _root
    width: 50
    height: 20
    radius: 5
    property string dm_text: "text"

    property bool _hovered: false
    property bool _pressed: false

    signal clicked

    color: _hovered == true ? "#ecf5ff" : "transparent"

    border {
        color: _pressed === true ? "#409eff" : (_hovered === true ? "#c6e2ff" : "#dcdfe6")
        width: 2
    }

    Text {
        anchors.centerIn: parent
        text: qsTr(dm_text)

        color: _hovered === true ? "#409eff" : "#606266"
        font {
            pixelSize: _root.height * 0.5
            bold: true
            family: "Microsoft YaHei"
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            _root._hovered = true
        }
        onExited: {
            _root._hovered = false
        }
        onPressed: {
            _root._pressed = true
        }
        onReleased: {
            _root._pressed = false
            _root.clicked()
        }
    }
}
