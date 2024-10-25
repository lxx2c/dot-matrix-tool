import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3

import DmBackend 1.0
import "./"

Window {
    id: _root
    width: 755
    height: 280
    minimumWidth: row_screen_params.width + 20
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

        _root.width = dot_matrix_screen.width + 20
        code_scorllview.height = 200
        _root.height = col_menu.y + row_file_select.height + row_screen_params.height
                + row_dot_mode.height + dot_matrix_screen.height + row_general.height
                + code_scorllview.height + col_menu.spacing * 6 + 10
    }
    //点阵左移
    function moveLeft() {
        var dotMatrix = dot_matrix_screen.getScreenPoints()
        for (let i in dotMatrix) {
            dotMatrix[i].x -= 1
        }
        dot_matrix_screen.clearScreen()
        dot_matrix_screen.setScreenPoints(dotMatrix)
    }
    //点阵右移
    function moveRight() {
        var dotMatrix = dot_matrix_screen.getScreenPoints()
        for (let i in dotMatrix) {
            dotMatrix[i].x += 1
        }
        dot_matrix_screen.clearScreen()
        dot_matrix_screen.setScreenPoints(dotMatrix)
    }
    //点阵上移
    function moveUp() {
        var dotMatrix = dot_matrix_screen.getScreenPoints()
        for (let i in dotMatrix) {
            dotMatrix[i].y -= 1
        }
        dot_matrix_screen.clearScreen()
        dot_matrix_screen.setScreenPoints(dotMatrix)
    }
    //点阵下移
    function moveDown() {
        var dotMatrix = dot_matrix_screen.getScreenPoints()
        for (let i in dotMatrix) {
            dotMatrix[i].y += 1
        }
        dot_matrix_screen.clearScreen()
        dot_matrix_screen.setScreenPoints(dotMatrix)
    }

    Column {
        x: 10
        y: 10
        spacing: 10
        //        anchors.bottom: parent.bottom
        //        anchors.bottomMargin: 10
        //        anchors.top: parent.top
        //        bottomPadding: 10
        id: col_menu
        Row {
            id: row_file_select
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
            id: row_screen_params
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
            id: row_dot_mode
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
                    text: qsTr("X:")+String(dot_matrix_screen.latest_x)
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
                    text: qsTr("Y:")+String(dot_matrix_screen.latest_y)
                    color: "white"
                    font.bold: true
                    font.pointSize: 10
                }
            }
        }

        Row {
            id: row_direction
            //            topPadding: -10
            DMButton {
                width: 80
                height: 30
                dm_text: "左"
                onClicked: {
                    moveLeft()
                }
                anchors.bottom: parent.bottom
            }
            Column {
                DMButton {
                    width: 80
                    height: 30
                    dm_text: "上"
                    onClicked: {
                        moveUp()
                    }
                }
                DMButton {
                    width: 80
                    height: 30
                    dm_text: "下"
                    onClicked: {
                        moveDown()
                    }
                }
                anchors.bottom: parent.bottom
            }

            DMButton {
                width: 80
                height: 30
                dm_text: "右"
                onClicked: {
                    moveRight()
                }
                anchors.bottom: parent.bottom
            }
        }

        DMScreen {
            id: dot_matrix_screen
            objectName: "dot_matrix_screen"
            onHeightChanged: {

            }
            onWidthChanged: {

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
            onYChanged: {
                code_scorllview.height = _root.height - row_general.y
                        - row_general.height - col_menu.spacing * 2 - 10
            }
        }

        ScrollView {
            id: code_scorllview
            clip: true
            height: 200
            width: row_screen_params.width

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
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        }
    }
    onWidthChanged: {

        backend.signalQmlValueChange()
    }
    onHeightChanged: {
        code_scorllview.height = _root.height - row_general.y
                - row_general.height - col_menu.spacing * 2 - 10
        backend.signalQmlValueChange()
    }
}
