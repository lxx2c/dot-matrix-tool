import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Window {
    id: _root
    width: 780
    height: 480
    visible: true
    title: qsTr("Dot-Matrix Tool")

    property int dot_row_point: 128
    property int dot_col_point: 32
    property int dot_spacing: 1
    property int dot_size: 8

    Column {
        x: 10
        y: 10
        spacing: 10
        Row {
            spacing: 5
            DMInputNumber {
                id: width_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "宽:"
                height: 20
                width: 80
                dm_value: dot_row_point
            }
            Text {
                id: name
                text: qsTr("*")
                y: parent.height / 2 - height / 2 + 2
            }
            DMInputNumber {
                id: height_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "高:"
                height: 20
                width: 80
                dm_value: dot_col_point
            }

            DMInputNumber {
                id: gap_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "间隙:"
                dm_max_length: 2
                height: 20
                width: 90
                dm_value: dot_spacing
            }
            DMInputNumber {
                id: size_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "色块大小:"
                dm_max_length: 2
                height: 20
                width: 120
                dm_value: dot_size
            }
            Button {
                height: size_input.height + 8
                //                anchors.verticalCenter: parent.verticalCenter
                text: "重新生成"
                onClicked: {
                    dot_row_point = width_input.dm_value
                    dot_col_point = height_input.dm_value
                    dot_size = size_input.dm_value
                    dot_spacing = gap_input.dm_value
                    _root.width = dot_matrix_screen.x + dot_matrix_screen.width + 20
                    _root.height = dot_matrix_screen.y + dot_matrix_screen.height + 20
                }
            }
        }
        Rectangle {
            id: dot_matrix_screen
            width: dot_row_point * (dot_size + dot_spacing) + dot_spacing
            height: dot_col_point * (dot_size + dot_spacing) + dot_spacing
            color: "white"
            property bool leftButtonPressed: false

            property int current_row_index: 0
            property int current_col_index: 0

            function hoveredCurrentDot(status) {
                var dot = _col_repeater.itemAt(
                            current_col_index).children[current_row_index]
                dot.isHovered = status
            }
            function reversalCurrentDot() {
                var dot = _col_repeater.itemAt(
                            current_col_index).children[current_row_index]
                dot.isChecked = !dot.isChecked
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onPressAndHold: {
                    console.log("hold")
                    var row = _col_repeater.itemAt(0)
                    var item = row.children[127]
                    console.log("item", item.x, item.y)
                }
                function getIndexForAxis(x, y) {
                    var x_index = Math.floor(x / (dot_size + dot_spacing))
                }

                onMouseXChanged: {
                    var row_index = Math.floor(
                                mouseX / (dot_size + dot_spacing))

                    if (row_index >= dot_row_point) {

                        row_index = row_index - 1
                    }
                    if (row_index != dot_matrix_screen.current_row_index) {
                        if (dot_matrix_screen.leftButtonPressed)
                            dot_matrix_screen.reversalCurrentDot()
                        dot_matrix_screen.hoveredCurrentDot(0)
                        dot_matrix_screen.current_row_index = row_index
                        dot_matrix_screen.hoveredCurrentDot(1)
                    }
                }
                onMouseYChanged: {
                    var col_index = Math.floor(
                                mouseY / (dot_size + dot_spacing))
                    if (col_index >= dot_col_point) {
                        col_index = col_index - 1
                    }
                    if (col_index != dot_matrix_screen.current_col_index) {
                        if (dot_matrix_screen.leftButtonPressed)
                            dot_matrix_screen.reversalCurrentDot()
                        dot_matrix_screen.hoveredCurrentDot(0)
                        dot_matrix_screen.current_col_index = col_index
                        dot_matrix_screen.hoveredCurrentDot(1)
                    }
                }
                onClicked: {
                    console.log("mouse ", mouseX, mouseY,
                                Math.floor(mouseX / (dot_size + dot_spacing)),
                                Math.floor(mouseY / (dot_size + dot_spacing)))
                }
                onPressed: {
                    dot_matrix_screen.leftButtonPressed = true
                }
                onReleased: {
                    dot_matrix_screen.leftButtonPressed = false
                    dot_matrix_screen.reversalCurrentDot()
                }
            }

            Column {
                x: dot_spacing
                y: dot_spacing
                anchors.fill: parent
                spacing: dot_spacing
                Repeater {
                    id: _col_repeater
                    model: dot_col_point
                    delegate: Row {
                        spacing: dot_spacing
                        Repeater {
                            model: dot_row_point
                            delegate: DotItem {
                                width: dot_size
                            }
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        _root.width = dot_matrix_screen.x + dot_matrix_screen.width + 20
        _root.height = dot_matrix_screen.y + dot_matrix_screen.height + 20
    }
}
