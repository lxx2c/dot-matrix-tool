import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Window {
    id: _root
    title: "新建"
    width: 400
    height: 300

    property string dm_file_name: ""
    property int dm_width_points
    property int dm_height_points
    property int dm_points_spacing
    property int dm_points_size
    property string dm_dot_checked_color

    property int dm_input_width_points
    property int dm_input_height_points
    property int dm_input_points_spacing
    property int dm_input_points_size
    property string dm_input_dot_checked_color

    signal dm_confirm

    Column {
        x: 10
        y: 30
        spacing: 20

        anchors.horizontalCenter: parent.horizontalCenter

        DMInput {
            id: file_name
            dm_name: "保存文件名"
            width: 200
            height: 20
            onDm_current_valueChanged: {
                dm_file_name = dm_current_value
            }
        }
        DMInputNumber {
            dm_name: "宽(像素点)"
            width: 200
            height: 20
            dm_input_value: dm_input_width_points
            onDm_current_valueChanged: {
                dm_width_points = dm_current_value
            }
        }
        DMInputNumber {
            dm_name: "高(像素点)"
            width: 200
            height: 20
            dm_input_value: dm_input_height_points
            onDm_current_valueChanged: {
                dm_height_points = dm_current_value
            }
        }
        DMInputNumber {
            dm_name: "-像素间隙-"
            width: 200
            height: 20
            dm_input_value: dm_input_points_spacing
            onDm_current_valueChanged: {
                dm_points_spacing = dm_current_value
            }
        }
        DMInputNumber {
            dm_name: "-色块大小-"
            width: 200
            height: 20
            dm_input_value: dm_input_points_size
            onDm_current_valueChanged: {
                dm_points_size = dm_current_value
            }
        }
        DMSelectColor {
            dm_name: "-色块颜色-"
            width: 200
            height: 20
            dm_input_value: dm_input_dot_checked_color
            onDm_current_valueChanged: {
                dm_dot_checked_color = dm_current_value
            }
        }

        Row {
            spacing: 50
            Button {
                text: "确定"
                width: 100
                height: 25
                onClicked: {
                    dm_confirm()
                    _root.close()
                }
            }

            Button {
                text: "取消"
                width: 100
                height: 25
                onClicked: {
                    _root.close()
                }
            }
        }
    }
}
