/****************************************************************************
** Meta object code from reading C++ file 'playlistmodel.h'
**
** Created: Thu May 19 10:18:15 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "playlistmodel.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'playlistmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_PlaylistModel[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      25,   15,   14,   14, 0x08,
      51,   14,   14,   14, 0x08,
      68,   15,   14,   14, 0x08,
      94,   14,   14,   14, 0x08,
     111,   15,   14,   14, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_PlaylistModel[] = {
    "PlaylistModel\0\0start,end\0"
    "beginInsertItems(int,int)\0endInsertItems()\0"
    "beginRemoveItems(int,int)\0endRemoveItems()\0"
    "changeItems(int,int)\0"
};

const QMetaObject PlaylistModel::staticMetaObject = {
    { &QAbstractItemModel::staticMetaObject, qt_meta_stringdata_PlaylistModel,
      qt_meta_data_PlaylistModel, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &PlaylistModel::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *PlaylistModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *PlaylistModel::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_PlaylistModel))
        return static_cast<void*>(const_cast< PlaylistModel*>(this));
    return QAbstractItemModel::qt_metacast(_clname);
}

int PlaylistModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractItemModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: beginInsertItems((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 1: endInsertItems(); break;
        case 2: beginRemoveItems((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 3: endRemoveItems(); break;
        case 4: changeItems((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        default: ;
        }
        _id -= 5;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
