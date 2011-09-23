#ifndef MYNETWORKINFO_H
#define MYNETWORKINFO_H

#include <QObject>
#include <QSystemNetworkInfo>

using namespace QtMobility;

class MyNetworkInfo : public QObject
{
    Q_OBJECT
public:
    explicit MyNetworkInfo(QObject *parent = 0);
    Q_INVOKABLE int getCellId();

signals:

public slots:

};

#endif // MYNETWORKINFO_H
