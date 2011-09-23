import Qt 4.7

Button{
    id:button

    checkable: true
    background: defaultbackground
    content: defaultlabel
    property variant value: checked

    Component {
        id:defaultbackground
        Item {
            Rectangle{
                anchors.fill:backgroundimage
                color:backgroundColor
                radius: 5
                x:1
                y:1
                width:parent.width-2
                height:parent.height-2
            }

            BorderImage {
                id: backgroundimage
                smooth:true
                anchors.left:parent.left
//                anchors.top:parent.top
//                anchors.bottom: parent.bottom

                source: "images/lineedit_normal.png"
                width: parent.height-5; height: parent.height-5
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
            }

            Image {
                opacity:checked ? (enabled ? 1:0.5) : 0
                source:"images/purplehandle.png"
                Behavior on opacity{NumberAnimation {duration: 150; easing.type:Easing.OutCubic}}
                anchors.centerIn:backgroundimage
//                anchors.verticalCenterOffset:1
//                anchors.horizontalCenterOffset:1
                width: backgroundimage.width; height:backgroundimage.height
            }
        }
    }

    Component {
        id:defaultlabel
        Item {
            width:layout.width
            height:layout.height

            anchors.bottom:parent.bottom
            anchors.margins:4
            Row {
                spacing:4
                anchors.bottom:parent.bottom
                id:layout
                Item{ width:28 ; height:1}
//                Item{ width:parent.height +8 ; height:1}
                Image { source:button.icon}
                Text {
                    color:button.foregroundColor;
                    opacity:enabled ? 1 : 0.5
                    font.pixelSize:14
                    text:button.text
                    y:4
                }
            }
        }
    }
}
