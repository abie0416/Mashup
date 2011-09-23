/****************************************************************************
** Meta object code from reading C++ file 'myqdeclarativeview.h'
**
** Created: Thu May 19 22:41:46 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../myqdeclarativeview.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'myqdeclarativeview.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_MyQDeclarativeView[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      20,   19,   19,   19, 0x05,

 // slots: signature, parameters, type, tag, flags
      35,   19,   19,   19, 0x0a,
      44,   19,   19,   19, 0x0a,

 // methods: signature, parameters, type, tag, flags
      68,   19,   63,   19, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_MyQDeclarativeView[] = {
    "MyQDeclarativeView\0\0playerHidden()\0"
    "myHide()\0handleHideWindow()\0bool\0"
    "myIsHidden()\0"
};

const QMetaObject MyQDeclarativeView::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_MyQDeclarativeView,
      qt_meta_data_MyQDeclarativeView, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &MyQDeclarativeView::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *MyQDeclarativeView::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *MyQDeclarativeView::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_MyQDeclarativeView))
        return static_cast<void*>(const_cast< MyQDeclarativeView*>(this));
    return QObject::qt_metacast(_clname);
}

int MyQDeclarativeView::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: playerHidden(); break;
        case 1: myHide(); break;
        case 2: handleHideWindow(); break;
        case 3: { bool _r = myIsHidden();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        default: ;
        }
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void MyQDeclarativeView::playerHidden()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
QT_END_MOC_NAMESPACE
