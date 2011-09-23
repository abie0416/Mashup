import Qt 4.7

//import QtMultimediaKit 1.1 // for camera?

import "mashupEngine.js" as Engine

import "services.js" as Services // for test service function.


Rectangle {
    // TODO: to use flipable effect.
    id:mainWindow
    width: 360
    height: 480
    color: "white"
    visible: true
    property string currentState: "baseState"

    signal showPlayerSignal()

    Component.onCompleted: {
        /* for test service function.*/
//        var x = new Services.Bandsintown_getArtistEvents("xx");
//        var arg = new Object();
//        arg.artist = "Syrano";
//        x.run(arg);

        Engine.engine.initAppHome();
        myConsole.log += "-----Initialization completed. \n\n";
    }

//    GPS {
//        id:gps
//        visible: false
//    }

    Rectangle {
        id:homeScreen
        anchors.fill:parent
        Image {
            id: image1
            x: 0
            y: 0
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            source: "images/background.jpeg"
        }
        Rectangle {
            radius:6
            anchors.fill:parent
            anchors.margins:10
            Image {
                id: image3
                x: 0
                y: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                source: "images/background.jpeg"
            }


            Flickable {
                id: flick1

                anchors.fill: parent
                contentHeight: items.height+items.y
                clip: true

                Column {
                    id: items
                    spacing: 25
                    y: 75
                }
            }
        }
    }

    Rectangle {
        id:executionScreen
        visible: false
        anchors.fill: parent
        Rectangle {
            radius:6
            anchors.fill:parent
            border.color: "#22000000"
            color: "#22ffffff"
            anchors.margins:10

            Flickable {
                id: flick2

                anchors.fill: parent
                contentHeight: ctrls.height
                clip: true

                Column {
                    id: ctrls
                    spacing: 5
                }
            }
            Button {
                id: userinputCancelButton
                x: mainWindow.width-width-25
                y: mainWindow.height-height-25
                text: "cancel"

                function cancel()
                {
                    console.log(mainWindow.currentState);
                    mainWindow.state = "baseState";
                }

                Component.onCompleted:userinputCancelButton.clicked.connect(cancel);
            }
        }

        gradient: Gradient{ GradientStop{ position:0 ; color:"#aaa"} GradientStop{ position:1 ; color:"#eee"}}
    }

    /* show the result with user's configuration.*/
    Rectangle {
        id: resultView
        visible: false
        width: 360
        height: 480

        Button {
            id: resultViewBackBtn
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            text: "back"
            function backHome()
            {
                mainWindow.state = "baseState";
            }

            Component.onCompleted:resultViewBackBtn.clicked.connect(backHome);
        }
    }

    /*
     * show the result in list view.
     * for test.
     */
    Rectangle {
        id: resultListView
        visible: false
        anchors.fill: parent
        Column {
            Text {
                id: resultTitle
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Mashup Result"
            }

            Button {
                id: resultButton
                anchors.top: resultTitle.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "back"
                onClicked: mainWindow.state = "State1" // go back to userinput screen.
            }
            Flickable {
                id: flick3

                anchors.top: resultButton.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                contentHeight: resultListItems.height+resultListItems.y
                clip: true


                Column {
                    id: resultListItems
                    spacing: 15
                    anchors.leftMargin: 25
                    anchors.left: parent.left
                    y: 75
                    Image {
                        width: 200
                        height: 100
                        source: "http://farm1.static.flickr.com/58/181730235_14013541d9_s.jpg"
                    }
                }
            }
        }
    }

    /* show console information.
     * add "myConsole.log += '*your information*'" in your program.
     */
    Rectangle {
        id: myConsole
        visible: false
        anchors.fill: parent
        property string log: ""

        Column {
            anchors.fill: parent
            Text {
                id: consoleHead
                anchors.horizontalCenter: parent.horizontalCenter
                text: "-----Check your log here:-----"
                font.bold: true
            }

            Flickable {
                anchors.top: consoleHead.bottom
                anchors.bottom: myConsoleButton.top
                anchors.left: parent.left
                anchors.right: parent.right
                contentHeight: consoleText.paintedHeight
                clip: true

                Text {
                    id: consoleText
                    text: myConsole.log
                }
            }

            Button {
                id: myConsoleButton
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                text: "back3"
                onClicked: {
                    mainWindow.state = currentState;
                    showConsoleButton.visible = true;

                    /* for test music module.*/
//                    var x = new Services.MobileMusic_playMusic("xx");
//                    x.run(null);
                }
            }
        }
    }

    /**********for mobile APIs*********/
    // handle music information when player is hidden.
    Rectangle {
        visible: false
        Connections {
            target: myView
            onPlayerHidden: {
                var results = new Array();
                var songInfo = new Object();
                myConsole.log += "onPlayerHidden\n";
                songInfo.artist = myView.getArtist();
                songInfo.songName = myView.getSongName();
                myConsole.log += "songArtist="+songInfo.artist+"\n";
                myConsole.log += "songName="+songInfo.songName+"\n";
                results.push(songInfo);
                Engine.engine.insertResult(results);
                Engine.engine.resume();
            }
        }
    }
    /**********************************/

    states: [
        State {
            name: "baseState"

        },

        State {
            name: "executeState"

            PropertyChanges {
                target: mainWindow
                currentState: "executeState"
            }

            PropertyChanges {
                target: image1
                visible: false
            }

            PropertyChanges {
                target: homeScreen
                visible: false
            }

            PropertyChanges {
                target: executionScreen
                visible: true
            }
        },
        State {
            name: "State2"

            PropertyChanges {
                target: mainWindow
                currentState: "State2"
            }

            PropertyChanges {
                target: image1
                visible: false
            }

            PropertyChanges {
                target: homeScreen
                visible: false
            }

            PropertyChanges {
                target: executionScreen
                visible: false
            }
            PropertyChanges {
                target: resultView
                visible: true
            }
        },
        State {
            name: "consoleState"

            PropertyChanges {
                target: image1
                visible: false
            }

            PropertyChanges {
                target: homeScreen
                visible: false
            }

            PropertyChanges {
                target: executionScreen
                visible: false
            }

            PropertyChanges {
                target: resultListView
                visible: false
            }

            PropertyChanges {
                target: myConsole
                visible: true
            }

            /* has to be set, or currentState will be set as default value.*/
            PropertyChanges {
                target: mainWindow
                currentState: currentState
            }


        },

        State {
            name: "ErrorBaseState"
            PropertyChanges {
                target: homeScreen
                opacity: 0.5
                enabled: false
            }

            PropertyChanges {
                target: executionScreen
                visible: false
            }
            PropertyChanges {
                target: mashupScreen
                visible: false
            }
        },
        State {
            name: "ErrorState1"
            PropertyChanges {
                target: homeScreen
                visible: false
            }

            PropertyChanges {
                target: executionScreen
                opacity: 0.5
                enabled: false
            }
            PropertyChanges {
                target: mashupScreen
                visible: false
            }
        },
        State {
            name: "ErrorState2"
            PropertyChanges {
                target: homeScreen
                visible: false
            }

            PropertyChanges {
                target: executionScreen
                visible: false
            }
            PropertyChanges {
                target: mashupScreen
                opacity: 0.5
                enabled: false
            }
        }

    ]

    Button {
        text: "Test Error Handler."
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        onClicked: {
            errorHandler.visible = true;
        }
    }

    Rectangle {
        id: errorHandler
        property alias text: errorText.text

        x: 50
        y: 150
        width: 200
        visible: false

        Column {
            spacing: 5
            Text {
                id:errorText
                text: "Something is wrong! Go back."
                font.pointSize: 15
                width: errorHandler.width
                color: "red"
                smooth: true
                wrapMode: Text.Wrap
            }

            Button {
                text: "OK"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    mainWindow.state = "baseState";
                    errorHandler.visible = false;
                }
            }
        }
        onVisibleChanged: {
            if(visible == true && mainWindow.state=="baseState") {
                console.log("Error happening!");
                mainWindow.state = "ErrorBaseState";
            } else if(visible == true && mainWindow.state=="State1") {
                console.log("Error happening!");
                mainWindow.state = "ErrorState1";
            } else if(visible == true && mainWindow.state=="State2") {
                console.log("Error happening!");
                mainWindow.state = "ErrorState2";
            }
        }
    }

    Button {
        id: showConsoleButton
        x: 15
        y: mainWindow.height-height-15
        text: "console"

        function showConsole()
        {
            mainWindow.state = "consoleState";
            showConsoleButton.visible = false;
        }

        Component.onCompleted:showConsoleButton.clicked.connect(showConsole);
    }

//    Timer {
//        id: timer
//        interval: 16
////        repeat: true
//        signal timeup
//        onTriggered: timeup()
//    }
}

