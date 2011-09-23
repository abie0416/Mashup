#ifndef PLAYER_H
#define PLAYER_H

#include <QtGui/QWidget>

#include <qmediaplayer.h>
#include <qmediaplaylist.h>
#include <qvideowidget.h>
#include <qaudioendpointselector.h>

#ifdef Q_OS_SYMBIAN
#include <QtGui/QDialog>
#include <QtGui/QLineEdit>
#include <QtGui/QListWidget>
#include <QtNetwork/QHttp>
//#include "mediakeysobserver.h"
#endif

class QAbstractItemView;
class QLabel;
class QModelIndex;
class QSlider;

class QMediaPlayer;
class QVideoWidget;

QT_USE_NAMESPACE

class PlaylistModel;

class Player : public QWidget
{
    Q_OBJECT
public:
    Player(QWidget *parent = 0);
    ~Player();

    QString getArtist();
    QString getSongName();

//Q_SIGNALS:
//    void fullScreenChanged(bool fullScreen);

signals:
    void hideWindow();

private slots:
    void open();
    void durationChanged(qint64 duration);
    void positionChanged(qint64 progress);
    void metaDataChanged();

    void previousClicked();

    void seek(int seconds);
    void jump(const QModelIndex &index);
    void playlistPositionChanged(int);

    void statusChanged(QMediaPlayer::MediaStatus status);
    void bufferingProgress(int progress);

    void displayErrorMessage();

#ifdef Q_OS_SYMBIAN
    void handleAspectRatio(bool aspectRatio);
    void handleStateChange(QMediaPlayer::State state);
//    void handleMediaKeyEvent(MediaKeysObserver::MediaKeys key);
    void showPlayList();
    void hideOrShowCoverArt();
    void launchYoutubeDialog();
    void youtubeHttpRequestFinished(int requestId, bool error);
    void youtubeReadResponseHeader(const QHttpResponseHeader& responseHeader);
    void searchYoutubeVideo();
    void addYoutubeVideo();
    void handleAudioOutputDefault();
    void handleAudioOutputAll();
    void handleAudioOutputNone();
    void handleAudioOutputEarphone();
    void handleAudioOutputSpeaker();
    void handleAudioOutputChangedSignal(const QString&);
#else
    void showColorDialog();
#endif

private:
    void setTrackInfo(const QString &info);
    void setStatusInfo(const QString &info);
    void handleCursor(QMediaPlayer::MediaStatus status);

#ifdef Q_OS_SYMBIAN
    void createMenus();
#endif

    QMediaPlayer *player;
    QMediaPlaylist *playlist;
    QVideoWidget *videoWidget;
    QLabel *coverLabel;
    QSlider *slider;
    QAudioEndpointSelector *audioEndpointSelector;
    PlaylistModel *playlistModel;
    QAbstractItemView *playlistView;
    QString trackInfo;
    QString statusInfo;
#ifdef Q_OS_SYMBIAN
//    MediaKeysObserver *mediaKeysObserver;
    QDialog *playlistDialog;
    QAction *toggleAspectRatio;
    QAction *showYoutubeDialog;
    QDialog *youtubeDialog;
    QHttp http;
    int httpGetId;
    QMenu *audioOutputMenu;
    QAction *setAudioOutputDefault;
    QAction *setAudioOutputAll;
    QAction *setAudioOutputNone;
    QAction *setAudioOutputEarphone;
    QAction *setAudioOutputSpeaker;
#else
    QDialog *colorDialog;
#endif
};

#endif
