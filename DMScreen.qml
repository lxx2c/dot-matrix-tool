import QtQuick 2.0

Rectangle {
    property var dm_screen_dot_matrix: [[0]]

    property int dm_dot_row_point: 1 //屏幕每行点数
    property int dm_dot_col_point: 1 //屏幕每列点数
    property int dm_dot_size: 8
    property int dm_dot_spacing: 1
    property string dm_dot_check_color: "green"

    id: _root
    width: dm_dot_row_point * (dm_dot_size + dm_dot_spacing) + dm_dot_spacing
    height: dm_dot_col_point * (dm_dot_size + dm_dot_spacing) + dm_dot_spacing
    color: "white"
    property bool leftButtonPressed: false

    property int latest_x: 0 //横向坐标序号
    property int latest_y: 0 //纵向坐标序号

    function setPoint(x, y) {
        var dot = _col_repeater.itemAt(y).children[x]
        dot.isChecked = true
    }

    function resetPoint(x, y) {
        var dot = _col_repeater.itemAt(y).children[x]
        dot.isChecked = false
    }

    function resizeScreenArray() {
        _root.dm_screen_dot_matrix = Array.from(
                    new Array(_root.dm_dot_col_point),
                    () => new Array(_root.dm_dot_row_point).fill(0)).map(
                    row => row.map(Boolean))
    }

    function clearScreen() {
        for (var y = 0; y < _root.dm_dot_col_point; y++) {
            for (var x = 0; x < _root.dm_dot_row_point; x++) {
                if (_root.dm_screen_dot_matrix[y][x] === true) {
                    _root.dm_screen_dot_matrix[y][x] = false
                    var dot = _col_repeater.itemAt(y).children[x]
                    dot.isChecked = false
                }
            }
        }
    }

    //鼠标hover
    function enterPoint(x, y) {
        if (x >= 0 && x < dm_dot_row_point && y >= 0 && y < dm_dot_col_point) {
            var dot = _col_repeater.itemAt(y).children[x]
            if (typeof (dot) === "object") {
                dot.isHovered = true
            }
        }
    }

    function exitPoint(x, y) {
        if (x >= 0 && x < dm_dot_row_point && y >= 0 && y < dm_dot_col_point) {
            var dot = _col_repeater.itemAt(y).children[x]
            if (typeof (dot) === "object") {
                dot.isHovered = false
            }
        }
    }

    //触发点反转
    function triggerPoint(x, y) {
        if (x >= 0 && x < dm_dot_row_point && y >= 0 && y < dm_dot_col_point) {
            var dot = _col_repeater.itemAt(y).children[x]
            dot.isChecked = !dot.isChecked
            //写入屏幕点阵数组
            _root.dm_screen_dot_matrix[y][x] = dot.isChecked
        }
    }

    //返回触发点
    function getScreenPoints() {
        var points = []
        for (var y = 0; y < _root.dm_dot_col_point; y++) {
            for (var x = 0; x < _root.dm_dot_row_point; x++) {
                if (_root.dm_screen_dot_matrix[y][x] === true) {
                    var point = Qt.point(x, y)
                    points.push(point)
                }
            }
        }
        return points
    }

    //设置触发点
    function setScreenPoints(points) {
        for (var index in points) {
            var x = points[index].x
            var y = points[index].y
            if ((points[index].x < _root.dm_dot_row_point)
                    & (points[index].y < _root.dm_dot_col_point)) {
                _root.setPoint(x, y)
                //写入屏幕点阵数组
                _root.dm_screen_dot_matrix[y][x] = true
            }
        }
        //        console.log("yx:", dm_screen_dot_matrix)
    }

    onDm_dot_col_pointChanged: {
        _root.resizeScreenArray()
    }
    onDm_dot_row_pointChanged: {
        _root.resizeScreenArray()
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        function getIndexForAxis(x, y) {
            var x_index = Math.floor(x / (dm_dot_size + dm_dot_spacing))
        }

        onMouseXChanged: {
            //鼠标X变化
            //计算当前x坐标对应点阵中的X轴方向点的序号
            var current_x = Math.floor(mouseX / (dm_dot_size + dm_dot_spacing))
            if (current_x >= dm_dot_row_point) {
                current_x = dm_dot_row_point - 1
            }
            if (current_x < 0) {
                current_x = 0
            }
            //发生变化时
            if (current_x != _root.latest_x) {
                //离开旧点
                _root.exitPoint(_root.latest_x, _root.latest_y)
                _root.latest_x = current_x
                //进入新点
                _root.enterPoint(_root.latest_x, _root.latest_y)
                //如果左键被按下
                if (_root.leftButtonPressed)
                    _root.triggerPoint(_root.latest_x, _root.latest_y)
            }
        }
        onMouseYChanged: {
            var current_y = Math.floor(mouseY / (dm_dot_size + dm_dot_spacing))
            if (current_y >= dm_dot_col_point) {
                current_y = dm_dot_col_point - 1
            }
            if (current_y < 0) {
                current_y = 0
            }
            if (current_y != _root.latest_y) {
                //离开旧点
                _root.exitPoint(_root.latest_x, _root.latest_y)
                _root.latest_y = current_y
                //进入新点
                _root.enterPoint(_root.latest_x, _root.latest_y)
                //如果左键被按下
                if (_root.leftButtonPressed)
                    _root.triggerPoint(_root.latest_x, _root.latest_y)
            }
        }
        onPressed: {
            _root.leftButtonPressed = true
            _root.triggerPoint(_root.latest_x, _root.latest_y)
        }
        onReleased: {
            _root.leftButtonPressed = false
        }
        onExited: {
            _root.exitPoint(_root.latest_x, _root.latest_y)
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
                //生成一行
                spacing: dm_dot_spacing
                Repeater {
                    model: dm_dot_row_point
                    delegate: DotItem {
                        width: dm_dot_size
                        checked_color: dm_dot_check_color
                    }
                }
            }
        }
    }
    onDm_dot_check_colorChanged: {

    }
}
