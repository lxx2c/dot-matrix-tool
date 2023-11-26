import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2

import DmBackend 1.0

Window {
    id: _root
    width: 755
    height: 480
    visible: true
    title: qsTr("Dot-Matrix Tool - default.ini")
    Backend {
        id: backend
        objectName: "qml_backend"
    }

    DMNewDialog {
        id: _new_dialog
        onDm_confirm: {
            console.log("confirm", _new_dialog.dm_file_name)
            backend.signalQmlCreateSetting(_new_dialog.dm_file_name)
            width_input.dm_input_value = _new_dialog.dm_width_points
            height_input.dm_input_value = _new_dialog.dm_height_points
            spacing_input.dm_input_value = _new_dialog.dm_points_spacing
            size_input.dm_input_value = _new_dialog.dm_points_size
            color_input.dm_input_value = _new_dialog.dm_dot_checked_color

            backend.signalQmlValueChange()

            resizeScreen()
        }
    }

    FileDialog {
        id: _file_dialog
        title: "选择打开的文件"
        nameFilters: ["ini文件 (*.ini)"]
        onAccepted: {
            backend.signalQmlOpenSetting(_file_dialog.fileUrl)
        }
    }

    //重设点阵屏大小
    function resizeScreen() {
        dot_matrix_screen.dm_dot_row_point = width_input.dm_current_value
        dot_matrix_screen.dm_dot_col_point = height_input.dm_current_value
        dot_matrix_screen.dm_dot_size = size_input.dm_current_value
        dot_matrix_screen.dm_dot_spacing = spacing_input.dm_current_value
    }

    Column {
        x: 10
        y: 10
        spacing: 10
        id: col_menu
        Row {
            spacing: 10
            Button {
                height: size_input.height + 8
                text: "新建"
                onClicked: {
                    _new_dialog.dm_input_width_points = width_input.dm_current_value
                    _new_dialog.dm_input_height_points = height_input.dm_current_value
                    _new_dialog.dm_input_points_spacing = spacing_input.dm_current_value
                    _new_dialog.dm_input_points_size = size_input.dm_current_value
                    _new_dialog.dm_input_dot_checked_color = color_input.dm_current_value
                    _new_dialog.show()
                }
            }
            Button {
                height: size_input.height + 8
                text: "打开"

                onClicked: {
                    _file_dialog.open()
                }
            }
            Text {
                anchors.bottom: parent.bottom
                text: qsTr("v0.1.1")
            }
        }

        Row {
            spacing: 5
            DMInputNumber {
                objectName: "Input_RowPoints"
                id: width_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "宽:"
                height: 20
                width: 80
            }
            Text {
                id: name
                text: qsTr("*")
                y: parent.height / 2 - height / 2 + 2
            }
            DMInputNumber {
                objectName: "Input_ColPoints"
                id: height_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "高:"
                height: 20
                width: 80
            }

            DMInputNumber {
                objectName: "Input_Spacing"
                id: spacing_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "间隙:"
                dm_max_length: 2
                height: 20
                width: 90
            }
            DMInputNumber {
                objectName: "Input_Size"
                id: size_input
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "色块大小:"
                dm_max_length: 2
                height: 20
                width: 120
            }
            DMSelectColor {
                objectName: "Input_Color"
                id: color_input
                height: 20
                width: 120
                anchors.verticalCenter: parent.verticalCenter
                dm_name: "色块颜色:"
                dm_size: 20
                onDm_current_valueChanged: {
                    dot_matrix_screen.dm_dot_check_color = dm_current_value
                    backend.signalQmlValueChange()
                }
            }

            Button {
                height: size_input.height + 8
                text: "重新生成"
                onClicked: {
                    resizeScreen()
                    backend.signalQmlValueChange()
                }
            }
            Button {
                height: size_input.height + 8
                text: "清空画面"
                onClicked: {
                    dot_matrix_screen.clearScreen()
                }
            }
        }
        Row {
            spacing: 5
            DMSelect {
                objectName: "Select_ReadMode"
                width: 150
                dm_name: "取模方式:"
                dm_model: ["逐行", "逐列", "行列式", "列行式"]
                onDm_current_valueChanged: {
                    backend.signalQmlValueChange()
                }
            }
            DMSelect {
                objectName: "Select_ReadDirection"
                width: 210
                dm_name: "取模方向:"
                dm_model: ["顺向(高位在前)", "逆向(低位在前)"]
                onDm_current_valueChanged: {
                    backend.signalQmlValueChange()
                }
            }
            DMSelect {
                objectName: "Select_UnitWidth"
                width: 100
                dm_name: "单位:"
                dm_model: ["8位", "16位", "32位"]
                onDm_current_valueChanged: {
                    backend.signalQmlValueChange()
                }
            }
            DMSelect {
                objectName: "Select_DotLevel"
                width: 110
                dm_name: "触点电平:"
                dm_model: ["1", "0"]
                onDm_current_valueChanged: {
                    backend.signalQmlValueChange()
                }
            }
            Rectangle {
                width: 70
                height: 22
                color: "red"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: current_x
                    text: qsTr("X:0")
                    color: "white"
                    font.bold: true
                    font.pointSize: 10
                }
            }
            Rectangle {
                width: 70
                height: 22
                color: "red"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: current_y
                    text: qsTr("Y:0")
                    color: "white"
                    font.bold: true
                    font.pointSize: 10
                }
            }
        }

        DMScreen {
            id: dot_matrix_screen
            objectName: "dot_matrix_screen"
            dm_dot_col_point: 20
            dm_dot_row_point: 20
            dm_dot_size: 10
            dm_dot_spacing: 1
            dm_screen_dot_matrix: [[0]]
            onDm_dot_col_pointChanged: {
                _root.resizeScreen()
            }
            onDm_dot_row_pointChanged: {
                _root.resizeScreen()
            }
            onLatest_xChanged: {
                current_x.text = "X:" + latest_x
            }
            onLatest_yChanged: {
                current_y.text = "Y:" + latest_y
            }
        }

        Row {
            id: row_general
            spacing: 10
            Button {
                id: btn_general
                height: 30
                width: 80
                text: "生成代码"
                onClicked: {
                    backend.signalQmlScreenMatrixPoint(
                                dot_matrix_screen.getScreenPoints())
                }
            }
            Button {
                id: btn_copy
                height: 30
                width: 50
                text: "复制"
                onClicked: {
                    text_code_generator.selectAll()
                    text_code_generator.copy()
                }
            }
            DMInputNumber {
                objectName: "Input_PerLineElements"
                anchors.verticalCenter: parent.verticalCenter
                height: btn_general.height - 10
                width: 150
                dm_name: "每行元素:"
                onDm_current_valueChanged: {
                    backend.signalQmlValueChange()
                }
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
            TextEdit {
                objectName: "text_code_generator"
                id: text_code_generator
                height: code_scorllview.height
                selectByMouse: true
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
        dot_matrix_screen.dm_dot_col_point = height_input.dm_current_value
        dot_matrix_screen.dm_dot_row_point = width_input.dm_current_value
    }
    onWidthChanged: {

        backend.signalQmlValueChange()
    }
    onHeightChanged: {

        backend.signalQmlValueChange()
    }
}
