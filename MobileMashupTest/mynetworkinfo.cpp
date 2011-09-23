#include "mynetworkinfo.h"

MyNetworkInfo::MyNetworkInfo(QObject *parent) :
    QObject(parent)
{
}

int MyNetworkInfo::getCellId()
{
    QSystemNetworkInfo* networkInfo = new QSystemNetworkInfo();
    return networkInfo->cellId();
}
