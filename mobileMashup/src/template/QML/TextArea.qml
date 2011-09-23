import Qt 4.7

Rectangle {
    id: rect
    width: 250
    height: 30
    color: "white"
    border.color: "black"
    clip: true
    property alias text: edit.text
    property variant value: text

    Flickable {
        id: flick

        anchors.fill: parent
        contentHeight: edit.paintedHeight
        clip: true

        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: edit
            width: flick.width
            height: flick.height
            focus: true
            wrapMode: TextEdit.Wrap
            text: "hello,world"
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
        }
    }
}
