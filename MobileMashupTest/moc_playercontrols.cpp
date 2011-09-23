/****************************************************************************
** Meta object code from reading C++ file 'playercontrols.h'
**
** Created: Thu May 19 21:17:40 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "playercontrols.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'playercontrols.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_PlayerControls[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      18,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      11,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   15,   15,   15, 0x05,
      23,   15,   15,   15, 0x05,
      31,   15,   15,   15, 0x05,
      38,   15,   15,   15, 0x05,
      45,   15,   15,   15, 0x05,
      63,   56,   15,   15, 0x05,
      88,   81,   15,   15, 0x05,
     112,  107,   15,   15, 0x05,
     130,   15,   15,   15, 0x05,
     137,   15,   15,   15, 0x05,
     150,   15,   15,   15, 0x05,

 // slots: signature, parameters, type, tag, flags
     171,  165,   15,   15, 0x0a,
     201,   56,   15,   15, 0x0a,
     222,  216,   15,   15, 0x0a,
     237,  107,   15,   15, 0x0a,
     260,   15,   15,   15, 0x08,
     274,   15,   15,   15, 0x08,
     288,   15,   15,   15, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_PlayerControls[] = {
    "PlayerControls\0\0play()\0pause()\0stop()\0"
    "next()\0previous()\0volume\0changeVolume(int)\0"
    "muting\0changeMuting(bool)\0rate\0"
    "changeRate(qreal)\0open()\0hideWindow()\0"
    "openPlayList()\0state\0setState(QMediaPlayer::State)\0"
    "setVolume(int)\0muted\0setMuted(bool)\0"
    "setPlaybackRate(float)\0playClicked()\0"
    "muteClicked()\0updateRate()\0"
};

const QMetaObject PlayerControls::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_PlayerControls,
      qt_meta_data_PlayerControls, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &PlayerControls::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *PlayerControls::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *PlayerControls::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_PlayerControls))
        return static_cast<void*>(const_cast< PlayerControls*>(this));
    return QWidget::qt_metacast(_clname);
}

int PlayerControls::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: play(); break;
        case 1: pause(); break;
        case 2: stop(); break;
        case 3: next(); break;
        case 4: previous(); break;
        case 5: changeVolume((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 6: changeMuting((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 7: changeRate((*reinterpret_cast< qreal(*)>(_a[1]))); break;
        case 8: open(); break;
        case 9: hideWindow(); break;
        case 10: openPlayList(); break;
        case 11: setState((*reinterpret_cast< QMediaPlayer::State(*)>(_a[1]))); break;
        case 12: setVolume((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 13: setMuted((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 14: setPlaybackRate((*reinterpret_cast< float(*)>(_a[1]))); break;
        case 15: playClicked(); break;
        case 16: muteClicked(); break;
        case 17: updateRate(); break;
        default: ;
        }
        _id -= 18;
    }
    return _id;
}

// SIGNAL 0
void PlayerControls::play()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void PlayerControls::pause()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void PlayerControls::stop()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void PlayerControls::next()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void PlayerControls::previous()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void PlayerControls::changeVolume(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void PlayerControls::changeMuting(bool _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void PlayerControls::changeRate(qreal _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 7, _a);
}

// SIGNAL 8
void PlayerControls::open()
{
    QMetaObject::activate(this, &staticMetaObject, 8, 0);
}

// SIGNAL 9
void PlayerControls::hideWindow()
{
    QMetaObject::activate(this, &staticMetaObject, 9, 0);
}

// SIGNAL 10
void PlayerControls::openPlayList()
{
    QMetaObject::activate(this, &staticMetaObject, 10, 0);
}
QT_END_MOC_NAMESPACE
