import Qt 4.7
//import "globalVars.js" as GlobalVars
//import "library.js" as Library

Rectangle {
    id:myitem
    width: 280
    height: 80
    radius: 10
    property string title
    property variant shortDesc
    property variant longDesc
    property variant userinputCtrls
    property int itemIndex

    signal itemClicked(int index)
    signal itemExecuted(int index)

    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#b0c4de"
        }

        GradientStop {
            position: 1
            color: "#0000ff"
        }
    }

    border.color: "blue"
    border.width: 3

    Image {
        id:itempic
        x: 7
        y: 8
        width: 40
        height: 40
        smooth:true
        source: "images/pic2.ico"
    }

    Button {
        id: button1
        x: 250
        y: 80
        visible: false
        text: "Next"
    }

    Text {
        id:itemname
        x: 50
        y: 8
        width: 210
        height: 28
        text: title
        color: "green"
        smooth: true
        font.family: "System"
        font.bold: true
        wrapMode: "WrapAtWordBoundaryOrAnywhere"
        Behavior on height {PropertyAnimation { duration: 200 }}
        Behavior on width {PropertyAnimation { duration: 200 }}
    }

    Text {
        id:itemintro
        x: 50
        y: 30
        width: 210
        height: 28
        text: shortDesc
        font.family: "System"
        font.pointSize: 5
        smooth: true
        wrapMode: "WrapAtWordBoundaryOrAnywhere"
        Behavior on height {PropertyAnimation { duration: 200 }}
        Behavior on width {PropertyAnimation { duration: 200 }}
    }

    MouseArea {
        id: mousearea1
        x: 30
        y: 30
        anchors.rightMargin: -3
        anchors.bottomMargin: -3
        anchors.leftMargin: 3
        anchors.topMargin: 3
        anchors.fill: parent

        onClicked: {
            myitem.itemClicked(itemIndex);
        }

        MouseArea {
            // for the button of executing a mashup
            id: mousearea2
            x: button1.x
            y: button1.y
            width: button1.width
            height: button1.height
            onClicked: myitem.itemExecuted(itemIndex)
        }
    }

    states: [
        State{
            name:"baseState"
        },

        State{
            name: "State1"
            PropertyChanges {
                target: button1
                visible: true

            }

            PropertyChanges {
                target: itemintro
                width: 266
                height: 75
                text: longDesc

            }
            PropertyChanges {
                target: myitem
                height: 130
                width: 330
                border.color: "green"

            }
        }
    ]

    Behavior on height {PropertyAnimation { duration: 200 }}
    Behavior on width {PropertyAnimation { duration: 200 }}
    Behavior on border.color {PropertyAnimation { duration: 200 }}
//    PropertyAnimation on y { to: 50; duration: 1000; loops: Animation.Infinite }

}


