import QtQuick 2.12

Rectangle {

    property color default_color: "gray"
    property color checked_color: "green"

    property bool isChecked: false
    property bool isHovered: false

    property bool isPressed: false
    height: width
    border.color: isHovered & !isChecked ? checked_color : "black"
    border.width: isHovered & !isChecked ? 2 : 1
    color: isChecked ? checked_color : default_color
}
