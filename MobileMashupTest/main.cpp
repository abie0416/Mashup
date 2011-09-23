#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QApplication>
#include <QtCore/QFileInfo>
#include <QtCore/QSettings>
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeNetworkAccessManagerFactory>
#include <QtNetwork/QNetworkConfiguration>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QtNetwork/QNetworkAccessManager>
#include <QtGui>

#include <mynetworkinfo.h>
#include <player.h>
#include <myqdeclarativeview.h>

//#include <Camera.h>
//#include <QCameraViewfinder>



int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    MyQDeclarativeView myView;

//    CameraExample camera;
//    camera.showFullScreen();

//    view.rootContext()->setContextProperty("camera", &camera);

    /* for getting cellid.*/
    MyNetworkInfo* myNetworkInfo = new MyNetworkInfo();
    myView.view.rootContext()->setContextProperty("myNetworkInfo", myNetworkInfo);

    myView.view.rootContext()->setContextProperty("myView", &myView);

    myView.view.show();

    return app.exec();

    /* for test desktop version.*/
//    QApplication app(argc, argv);
//    QDeclarativeView myView;
//    myView.setSource(QUrl("qrc:MashupUI.qml"));
//    myView.show();
//    return app.exec();

}
