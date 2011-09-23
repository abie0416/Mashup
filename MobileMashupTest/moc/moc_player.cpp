/****************************************************************************
** Meta object code from reading C++ file 'player.h'
**
** Created: Sat May 21 18:10:54 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../player.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'player.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Player[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
      27,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
       8,    7,    7,    7, 0x05,

 // slots: signature, parameters, type, tag, flags
      21,    7,    7,    7, 0x08,
      37,   28,    7,    7, 0x08,
      70,   61,    7,    7, 0x08,
      94,    7,    7,    7, 0x08,
     112,    7,    7,    7, 0x08,
     138,  130,    7,    7, 0x08,
     154,  148,    7,    7, 0x08,
     172,    7,    7,    7, 0x08,
     208,  201,    7,    7, 0x08,
     249,   61,    7,    7, 0x08,
     272,    7,    7,    7, 0x08,
     306,  294,    7,    7, 0x08,
     336,  330,    7,    7, 0x08,
     375,    7,    7,    7, 0x08,
     390,    7,    7,    7, 0x08,
     411,    7,    7,    7, 0x08,
     449,  433,    7,    7, 0x08,
     501,  486,    7,    7, 0x08,
     548,    7,    7,    7, 0x08,
     569,    7,    7,    7, 0x08,
     587,    7,    7,    7, 0x08,
     614,    7,    7,    7, 0x08,
     637,    7,    7,    7, 0x08,
     661,    7,    7,    7, 0x08,
     689,    7,    7,    7, 0x08,
     716,    7,    7,    7, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_Player[] = {
    "Player\0\0hideWindow()\0open()\0duration\0"
    "durationChanged(qint64)\0progress\0"
    "positionChanged(qint64)\0metaDataChanged()\0"
    "previousClicked()\0seconds\0seek(int)\0"
    "index\0jump(QModelIndex)\0"
    "playlistPositionChanged(int)\0status\0"
    "statusChanged(QMediaPlayer::MediaStatus)\0"
    "bufferingProgress(int)\0displayErrorMessage()\0"
    "aspectRatio\0handleAspectRatio(bool)\0"
    "state\0handleStateChange(QMediaPlayer::State)\0"
    "showPlayList()\0hideOrShowCoverArt()\0"
    "launchYoutubeDialog()\0requestId,error\0"
    "youtubeHttpRequestFinished(int,bool)\0"
    "responseHeader\0"
    "youtubeReadResponseHeader(QHttpResponseHeader)\0"
    "searchYoutubeVideo()\0addYoutubeVideo()\0"
    "handleAudioOutputDefault()\0"
    "handleAudioOutputAll()\0handleAudioOutputNone()\0"
    "handleAudioOutputEarphone()\0"
    "handleAudioOutputSpeaker()\0"
    "handleAudioOutputChangedSignal(QString)\0"
};

const QMetaObject Player::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_Player,
      qt_meta_data_Player, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Player::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Player::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Player::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Player))
        return static_cast<void*>(const_cast< Player*>(this));
    return QWidget::qt_metacast(_clname);
}

int Player::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: hideWindow(); break;
        case 1: open(); break;
        case 2: durationChanged((*reinterpret_cast< qint64(*)>(_a[1]))); break;
        case 3: positionChanged((*reinterpret_cast< qint64(*)>(_a[1]))); break;
        case 4: metaDataChanged(); break;
        case 5: previousClicked(); break;
        case 6: seek((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 7: jump((*reinterpret_cast< const QModelIndex(*)>(_a[1]))); break;
        case 8: playlistPositionChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 9: statusChanged((*reinterpret_cast< QMediaPlayer::MediaStatus(*)>(_a[1]))); break;
        case 10: bufferingProgress((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 11: displayErrorMessage(); break;
        case 12: handleAspectRatio((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 13: handleStateChange((*reinterpret_cast< QMediaPlayer::State(*)>(_a[1]))); break;
        case 14: showPlayList(); break;
        case 15: hideOrShowCoverArt(); break;
        case 16: launchYoutubeDialog(); break;
        case 17: youtubeHttpRequestFinished((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 18: youtubeReadResponseHeader((*reinterpret_cast< const QHttpResponseHeader(*)>(_a[1]))); break;
        case 19: searchYoutubeVideo(); break;
        case 20: addYoutubeVideo(); break;
        case 21: handleAudioOutputDefault(); break;
        case 22: handleAudioOutputAll(); break;
        case 23: handleAudioOutputNone(); break;
        case 24: handleAudioOutputEarphone(); break;
        case 25: handleAudioOutputSpeaker(); break;
        case 26: handleAudioOutputChangedSignal((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        default: ;
        }
        _id -= 27;
    }
    return _id;
}

// SIGNAL 0
void Player::hideWindow()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
QT_END_MOC_NAMESPACE
