import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: _root
    width: 780
    height: 480
    visible: true
    title: qsTr("Dot-Matrix Tool")

    property int dot_row_point: 20
    property int dot_col_point: 20
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
                    dot_matrix_screen.dm_dot_row_point = width_input.dm_value
                    dot_matrix_screen.dm_dot_col_point = height_input.dm_value
                    dot_matrix_screen.dm_dot_size = size_input.dm_value
                    dot_matrix_screen.dm_dot_spacing = gap_input.dm_value
                    if (dot_matrix_screen.width > code_scorllview.width) {
                        _root.width = dot_matrix_screen.x + dot_matrix_screen.width + 20
                    } else {
                        _root.width = code_scorllview.x + code_scorllview.width + 20
                    }

                    _root.height = code_scorllview.y + code_scorllview.height + 20
                }
            }
        }
        Row {
            spacing: 5
            DMSelect {
                width: 220
                dm_name: "读取模式:"
                dm_model: ["逐行-从左到右", "逐行-从左到右", "逐列-从上到下", "逐行-从下到上"]
                onDm_select_indexChanged: {
                    console.log(dm_select_index)
                }
            }
            DMSelect {
                width: 150
                dm_name: "其他:"
                dm_model: ["高位在前", "高位在后"]
            }
            DMSelect {
                width: 150
                dm_name: "单位:"
                dm_model: ["uint8_t", "uint16_t", "uint32_t", "uint64_t"]
            }
        }

        DMScreen {
            id: dot_matrix_screen
            dm_dot_col_point: dot_col_point
            dm_dot_row_point: dot_row_point
            dm_dot_size: dot_size
            dm_dot_spacing: dot_spacing
        }

        Row {
            spacing: 10
            Button {
                text: "生成代码"
            }

            Button {
                text: "复制"
            }
        }

        ScrollView {
            id: code_scorllview
            width: 800
            height: 100
            clip: true
            background: Rectangle {
                color: "#f0f0f0"
                border.color: "black"
                border.width: 1
            }
            TextArea {
                id: text_code_generator
            }
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
        }
    }
    Component.onCompleted: {
        if (dot_matrix_screen.width > code_scorllview.width) {
            _root.width = dot_matrix_screen.x + dot_matrix_screen.width + 20
        } else {
            _root.width = code_scorllview.x + code_scorllview.width + 20
        }
        _root.height = code_scorllview.y + code_scorllview.height + 20
        dot_matrix_screen.dm_dot_col_point = dot_col_point
    }
}
