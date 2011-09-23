#ifndef MYQDECLARATIVEVIEW_H
#define MYQDECLARATIVEVIEW_H

#include <QObject>
#include <QDeclarativeView>
#include <QMainWindow>
#include <player.h>

class MyQDeclarativeView : public QObject
{
    Q_OBJECT
public:
    explicit MyQDeclarativeView(QObject *parent = 0);
    Q_INVOKABLE QString getArtist();
    Q_INVOKABLE QString getSongName();

    QDeclarativeView view;
    QMainWindow window;
    Player* player;

signals:
    void playerHidden();

public slots:
    void myHide();
    void handleHideWindow();

};

#endif // MYQDECLARATIVEVIEW_H
