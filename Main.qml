import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import DmBackend 1.0

Window {
    id: _root
    width: 780
    height: 480
    visible: true
    title: qsTr("Dot-Matrix Tool")

    property int dot_row_point: 10 //屏幕每行点数
    property int dot_col_point: 20 //屏幕每列点数
    property int dot_spacing: 1
    property int dot_size: 8

    Backend {
        id: backend
        objectName: "qml_backend"
    }

    function resizeScreen() {
        dot_matrix_screen.dm_dot_row_point = width_input.dm_value
        dot_matrix_screen.dm_dot_col_point = height_input.dm_value
        dot_matrix_screen.dm_dot_size = size_input.dm_value
        dot_matrix_screen.dm_dot_spacing = gap_input.dm_value

        if (dot_matrix_screen.width > code_scorllview.width) {
            _root.width = dot_matrix_screen.x + dot_matrix_screen.width + 20
        } else {
            _root.width = code_scorllview.x + code_scorllview.width + 20
        }
    }

    Column {
        x: 10
        y: 10
        spacing: 10
        Row {
            spacing: 5
            DMInputNumber {
                objectName: "Input_Row_Point"
                id: width_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "宽:"
                height: 20
                width: 80
                dm_value: dot_row_point
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Input_Row_Point)
                }
            }
            Text {
                id: name
                text: qsTr("*")
                y: parent.height / 2 - height / 2 + 2
            }
            DMInputNumber {
                objectName: "Input_Col_Point"
                id: height_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "高:"
                height: 20
                width: 80
                dm_value: dot_col_point
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Input_Col_Point)
                }
            }

            DMInputNumber {
                objectName: "Input_Spacing"
                id: gap_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "间隙:"
                dm_max_length: 2
                height: 20
                width: 90
                dm_value: dot_spacing
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Input_Spacing)
                }
            }
            DMInputNumber {
                objectName: "Input_Size"
                id: size_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "色块大小:"
                dm_max_length: 2
                height: 20
                width: 120
                dm_value: dot_size
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Input_Size)
                }
            }
            Button {
                height: size_input.height + 8
                //                anchors.verticalCenter: parent.verticalCenter
                text: "重新生成"
                onClicked: {
                    resizeScreen()
                    var points = dot_matrix_screen.getScreenPoints()
                    console.log("points ", points)
                    dot_matrix_screen.setScreenPoints(points)
                }
            }
        }
        Row {
            spacing: 5
            DMSelect {
                objectName: "Select_Read"
                width: 220
                dm_name: "读取模式:"
                dm_model: ["逐行-从左到右", "逐行-从右到左", "逐列-从上到下", "逐行-从下到上"]
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Select_Read)
                }
            }
            DMSelect {
                objectName: "Select_Storage"
                width: 200
                dm_name: "存储方式:"
                dm_model: ["高位在前", "高位在后"]
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Select_Storage)
                }
            }
            DMSelect {
                objectName: "Select_Unit"
                width: 150
                dm_name: "单位:"
                dm_model: ["uint8_t", "uint16_t", "uint32_t", "uint64_t"]
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Select_Unit)
                }
            }
            DMSelect {
                objectName: "Select_Level"
                width: 150
                dm_name: "触点电平:"
                dm_model: ["0", "1"]
                onDm_valueChanged: {
                    backend.signalQmlValueChange(Backend.Select_Level)
                }
            }
        }

        DMScreen {
            id: dot_matrix_screen
            objectName: "dot_matrix_screen"
            dm_dot_col_point: dot_col_point
            dm_dot_row_point: dot_row_point
            dm_dot_size: dot_size
            dm_dot_spacing: dot_spacing
            dm_screen_dot_matrix: [[0]]
            onDm_dot_col_pointChanged: {
                _root.resizeScreen()
            }
        }

        Row {
            spacing: 10
            Button {
                text: "生成代码"
                onClicked: {
                    backend.signalQmlBuildButtonClicked()
                    backend.signalQmlScreenMatrixPoint(
                                dot_matrix_screen.getScreenPoints())
                }
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
        dot_matrix_screen.dm_dot_row_point = dot_row_point
    }
    onWidthChanged: {

        backend.signalQmlValueChange(Backend.Window_Width)
    }
    onHeightChanged: {

        backend.signalQmlValueChange(Backend.Window_Height)
    }
}
