import QtQuick 2.0

Rectangle {
    property var dm_screen_dot_matrix: [[0]]
    property var dm_screen_actived_points: []

    property int dm_dot_row_point: 2
    //屏幕每行点数
    property int dm_dot_col_point: 2
    //屏幕每列点数
    property int dm_dot_size: 6
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
        if (y < 0 || y >= dm_dot_col_point || x < 0 || x >= dm_dot_row_point) {
            return
        }
        var dot = _root.getDotItem(x, y)
        dot.isChecked = true
    }

    function resetPoint(x, y) {
        if (x >= 0 && x < dm_dot_row_point && y >= 0 && y < dm_dot_col_point) {
            var dot = _root.getDotItem(x, y)
            dot.isChecked = false
        }
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
                    resetPoint(x, y)
                }
            }
        }
    }

    //触发点反转
    function triggerPoint(x, y) {
        if (x >= 0 && x < dm_dot_row_point && y >= 0 && y < dm_dot_col_point) {
            var dot = _root.getDotItem(x, y)
            dot.isChecked = !dot.isChecked
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
            if ((x < _root.dm_dot_row_point) && (y < _root.dm_dot_col_point)
                    && (y >= 0) && (x >= 0)) {
                _root.setPoint(x, y)
                _root.dm_screen_dot_matrix[y][x] = true
            }
        }
    }

    function getDotItem(x, y) {
        var index = y * dot_matrix_screen.dm_dot_row_point + x
        if (index >= 0 && index < _grid_repeater.count) {
            return _grid_repeater.itemAt(y * dm_dot_row_point + x)
        } else {
            return null
        }
    }

    onDm_dot_col_pointChanged: {
        console.log("col", dm_dot_col_point)
        _root.resizeScreenArray()
    }
    onDm_dot_row_pointChanged: {
        console.log("row", dm_dot_row_point)
        _root.resizeScreenArray()
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onMouseXChanged: {
            //鼠标X变化
            //计算当前x坐标对应点阵中的X轴方向点的序号
            var current_x = Math.floor(mouseX / (dm_dot_size + dm_dot_spacing))
            current_x = Math.max(0, Math.min(current_x, dm_dot_row_point - 1))
            //发生变化时
            if (current_x != _root.latest_x) {
                _root.latest_x = current_x
                //如果左键被按下
                if (_root.leftButtonPressed)
                    _root.triggerPoint(_root.latest_x, _root.latest_y)
            }
        }
        onMouseYChanged: {
            var current_y = Math.floor(mouseY / (dm_dot_size + dm_dot_spacing))
            current_y = Math.max(0, Math.min(current_y, dm_dot_col_point - 1))
            //发生变化时
            if (current_y != _root.latest_y) {
                _root.latest_y = current_y
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
            _root.latest_x = -1
            _root.latest_y = -1
        }
    }

    Grid {
        rows: dm_dot_col_point
        columns: dm_dot_row_point
        spacing: dm_dot_spacing
        anchors.fill: parent
        Repeater {
            id: _grid_repeater
            model: dm_dot_col_point * dm_dot_row_point
            delegate: DotItem {
                width: dm_dot_size
                checked_color: dm_dot_check_color
                isHovered:((_root.latest_x > -1) && (_root.latest_y > -1) && (_root.latest_y*dm_dot_row_point+_root.latest_x) === index)?true:false
            }
        }
    }
}
