/****************************************************************************
** Meta object code from reading C++ file 'mynetworkinfo.h'
**
** Created: Thu May 19 18:16:57 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../mynetworkinfo.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mynetworkinfo.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MyNetworkInfo[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: signature, parameters, type, tag, flags
      19,   14,   15,   14, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_MyNetworkInfo[] = {
    "MyNetworkInfo\0\0int\0getCellId()\0"
};

const QMetaObject MyNetworkInfo::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_MyNetworkInfo,
      qt_meta_data_MyNetworkInfo, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MyNetworkInfo::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MyNetworkInfo::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MyNetworkInfo::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MyNetworkInfo))
        return static_cast<void*>(const_cast< MyNetworkInfo*>(this));
    return QObject::qt_metacast(_clname);
}

int MyNetworkInfo::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: { int _r = getCellId();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
