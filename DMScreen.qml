import QtQuick 2.0

Rectangle {
    property var dm_screen_dot_matrix: [[0], [0]]

    property int dm_dot_row_point: 128
    property int dm_dot_col_point: 1
    property int dm_dot_size: 8
    property int dm_dot_spacing: 1

    id: _root
    width: dm_dot_row_point * (dm_dot_size + dm_dot_spacing) + dm_dot_spacing
    height: dm_dot_col_point * (dm_dot_size + dm_dot_spacing) + dm_dot_spacing
    color: "white"
    property bool leftButtonPressed: false

    property int current_row_index: 0
    property int current_col_index: 0

    function hoveredCurrentDot(status) {
        var dot = _col_repeater.itemAt(
                    current_row_index).children[current_col_index]
        dot.isHovered = status
    }
    function reversalCurrentDot() {
        var dot = _col_repeater.itemAt(
                    current_row_index).children[current_col_index]
        dot.isChecked = !dot.isChecked

        dm_screen_dot_matrix[current_row_index][current_col_index] = Number(
                    dot.isChecked)

        console.log("row", current_row_index, "col", current_col_index)
        console.log("dm_screen_dot_matrix")
        for (var i = 0; i < dm_dot_col_point; i++) {
            console.log(i, dm_screen_dot_matrix[i])
        }
    }
    onDm_screen_dot_matrixChanged: {
        console.log("screen-dot", dm_screen_dot_matrix)
    }

    onDm_dot_col_pointChanged: {
        dm_screen_dot_matrix = [[0]]

        for (var i = 0; i < dm_dot_row_point; i++) {
            while (dm_screen_dot_matrix[i].length < dm_dot_col_point) {
                dm_screen_dot_matrix[i].push(0)
            }
            dm_screen_dot_matrix.push([0])
        }
    }
    onDm_dot_row_pointChanged: {
        dm_screen_dot_matrix = [[0]]
        for (var i = 0; i < dm_dot_row_point; i++) {
            while (dm_screen_dot_matrix[i].length < dm_dot_col_point) {
                dm_screen_dot_matrix[i].push(0)
            }
            dm_screen_dot_matrix.push([0])
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        //        onPressAndHold: {
        //            console.log("hold")
        //            var row = _col_repeater.itemAt(0)
        //            var item = row.children[127]
        //            console.log("item", item.x, item.y)
        //        }
        function getIndexForAxis(x, y) {
            var x_index = Math.floor(x / (dm_dot_size + dm_dot_spacing))
        }

        onMouseXChanged: {
            var col_index = Math.floor(mouseX / (dm_dot_size + dm_dot_spacing))
            if (col_index >= dm_dot_col_point) {
                col_index = col_index - 1
            }
            if (col_index != _root.current_col_index) {
                if (_root.leftButtonPressed)
                    _root.reversalCurrentDot()
                _root.hoveredCurrentDot(0)
                _root.current_col_index = col_index
                _root.hoveredCurrentDot(1)
            }
        }
        onMouseYChanged: {
            var row_index = Math.floor(mouseY / (dm_dot_size + dm_dot_spacing))

            if (row_index >= dm_dot_row_point) {

                row_index = row_index - 1
            }
            if (row_index != _root.current_row_index) {
                if (_root.leftButtonPressed)
                    _root.reversalCurrentDot()
                _root.hoveredCurrentDot(0)
                _root.current_row_index = row_index
                _root.hoveredCurrentDot(1)
            }
        }
        onClicked: {
            console.log("mouse ", mouseX, mouseY,
                        Math.floor(mouseX / (dm_dot_size + dm_dot_spacing)),
                        Math.floor(mouseY / (dm_dot_size + dm_dot_spacing)))
        }
        onPressed: {
            _root.leftButtonPressed = true
        }
        onReleased: {
            _root.leftButtonPressed = false
            _root.reversalCurrentDot()
        }
        onExited: {
            _root.hoveredCurrentDot(0)
        }
    }

    Column {
        x: dm_dot_spacing
        y: dm_dot_spacing
        anchors.fill: parent
        spacing: dm_dot_spacing
        Repeater {
            id: _col_repeater
            model: dm_dot_col_point
            delegate: Row {
                spacing: dm_dot_spacing
                Repeater {
                    model: dm_dot_row_point
                    delegate: DotItem {
                        width: dm_dot_size
                    }
                }
            }
        }
    }
}
