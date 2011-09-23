#-------------------------------------------------
#
# Project created by QtCreator 2011-01-07T09:35:35
#
#-------------------------------------------------

QT += core declarative network xml

INCLUDEPATH += D:/QtSDK/Symbian/SDKs/Symbian1Qt473/src/multimedia \
                 D:/QtSDK/Symbian/SDKs/Symbian1Qt473/src/multimedia/audio \

SOURCES += main.cpp \
#    Button.cpp \
#    Camera.cpp
    player.cpp \
#    mediakeysobserver.cpp \
    playercontrols.cpp \
    videowidget.cpp \
    mynetworkinfo.cpp \
    playlistmodel.cpp \
    myqdeclarativeview.cpp

CONFIG += mobility
MOBILITY = multimedia \
     systeminfo \
     location

symbian {
    TARGET.EPOCHEAPSIZE = 0x20000 0x2000000

    # For QtMobility
    TARGET.CAPABILITY = NetworkServices \
#       ProtServ \
#       SwEvent \
       LocalServices \
       ReadUserData \
       WriteUserData \
#       SurroundingsDD \
       UserEnvironment \
       ReadDeviceData \
       Location \
       WriteDeviceData \
       SwEvent
#       MultimediaDD \
#       TrustedUI

}

OTHER_FILES += \
    TextArea.qml \
    Myitem.qml \
    MashupUI.qml \
    mashupEngine.js \
    library.js \
    environment.js \
    config.js \
    Checkbox.qml \
    Button.qml \
    Base64.js \
    images/title.png \
    images/tick2.png \
    images/tick1.png \
    images/spinbox_up.png \
    images/spinbox_normal.png \
    images/spinbox_down.png \
    images/slider-handle-active.png \
    images/slider-handle.png \
    images/slider-background.png \
    images/slider.png \
    images/qt-logo.png \
    images/purplehandle.png \
    images/progress-bar-bar.png \
    images/progress-bar-background.png \
    images/pic2.ico \
    images/my-slider-progress.png \
    images/my-slider-bkg.png \
    images/my-knob.png \
    images/lineedit_normal.png \
    images/handle.png \
    images/checkbox-unchecked.png \
    images/checkbox-checked.png \
    images/button_pressed.png \
    images/button_normal.png \
    images/bt_red_pressed.png \
    images/bt_red.png \
    images/bt_gray_pressed.png \
    images/bt_gray.png \
    images/background.jpeg \
    js/stack.js \
    js/map.js \
    js/generateCtrls.js \
    js/events.js \
    GPS.qml \
    model.js \
    services.js \
    resultPageConfig.js

RESOURCES += \
    MobileMashupResource.qrc

#HEADERS += \
#    Button.h \
#    Camera.h

HEADERS += \
    player.h \
#    mediakeysobserver.h \
    playercontrols.h \
    videowidget.h \
    mynetworkinfo.h \
    playlistmodel.h \
    myqdeclarativeview.h
