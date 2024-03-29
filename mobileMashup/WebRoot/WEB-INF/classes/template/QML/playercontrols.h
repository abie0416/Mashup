#ifndef PLAYERCONTROLS_H
#define PLAYERCONTROLS_H

#include <qmediaplayer.h>

#include <QtGui/qwidget.h>

class QAbstractButton;
class QAbstractSlider;
class QComboBox;

QT_USE_NAMESPACE

class PlayerControls : public QWidget
{
    Q_OBJECT
public:
    PlayerControls(QWidget *parent = 0);

    QMediaPlayer::State state() const;

    int volume() const;
    bool isMuted() const;
    qreal playbackRate() const;

public slots:
    void setState(QMediaPlayer::State state);
    void setVolume(int volume);
    void setMuted(bool muted);
    void setPlaybackRate(float rate);

signals:
    void play();
    void pause();
    void stop();
    void next();
    void previous();
    void changeVolume(int volume);
    void changeMuting(bool muting);
    void changeRate(qreal rate);
#ifdef Q_OS_SYMBIAN
    void open();
    void hideWindow();
    void openPlayList();
#endif

private slots:
    void playClicked();
    void muteClicked();
    void updateRate();

private:
    QMediaPlayer::State playerState;
    bool playerMuted;
    QAbstractButton *playButton;
    QAbstractButton *stopButton;
    QAbstractButton *nextButton;
    QAbstractButton *previousButton;
    QAbstractButton *muteButton;
#ifdef Q_OS_SYMBIAN
    QAbstractButton *openButton;
    QAbstractButton *hideWindowButton;
    QAbstractButton *playListButton;
#else
    QAbstractSlider *volumeSlider;
    QComboBox *rateBox;
#endif
};

#endif
