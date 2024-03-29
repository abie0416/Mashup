#include "playercontrols.h"

#include <QtGui/qboxlayout.h>
#include <QtGui/qslider.h>
#include <QtGui/qstyle.h>
#include <QtGui/qtoolbutton.h>
#include <QtGui/qcombobox.h>

PlayerControls::PlayerControls(QWidget *parent)
    : QWidget(parent)
    , playerState(QMediaPlayer::StoppedState)
    , playerMuted(false)
    , playButton(0)
    , stopButton(0)
    , nextButton(0)
    , previousButton(0)
    , muteButton(0)
#ifdef Q_OS_SYMBIAN
    , openButton(0)
    , hideWindowButton(0)
    , playListButton(0)
#else
    , volumeSlider(0)
    , rateBox(0)
#endif
{
    playButton = new QToolButton(this);
    playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));

    connect(playButton, SIGNAL(clicked()), this, SLOT(playClicked()));

    stopButton = new QToolButton(this);
    stopButton->setIcon(style()->standardIcon(QStyle::SP_MediaStop));
    stopButton->setEnabled(false);

    connect(stopButton, SIGNAL(clicked()), this, SIGNAL(stop()));

    nextButton = new QToolButton(this);
    nextButton->setIcon(style()->standardIcon(QStyle::SP_MediaSkipForward));

    connect(nextButton, SIGNAL(clicked()), this, SIGNAL(next()));

    previousButton = new QToolButton(this);
    previousButton->setIcon(style()->standardIcon(QStyle::SP_MediaSkipBackward));

    connect(previousButton, SIGNAL(clicked()), this, SIGNAL(previous()));

    muteButton = new QToolButton(this);
    muteButton->setIcon(style()->standardIcon(QStyle::SP_MediaVolume));

    connect(muteButton, SIGNAL(clicked()), this, SLOT(muteClicked()));

#ifndef Q_OS_SYMBIAN
    volumeSlider = new QSlider(Qt::Horizontal, this);

#ifndef Q_WS_MAEMO_5
    volumeSlider->setRange(0, 100);

    connect(volumeSlider, SIGNAL(sliderMoved(int)), this, SIGNAL(changeVolume(int)));
#endif

    rateBox = new QComboBox(this);
    rateBox->addItem("0.5x", QVariant(0.5));
    rateBox->addItem("1.0x", QVariant(1.0));
    rateBox->addItem("2.0x", QVariant(2.0));
    rateBox->setCurrentIndex(1);

    connect(rateBox, SIGNAL(activated(int)), SLOT(updateRate()));

#endif
#ifdef Q_OS_SYMBIAN
    playButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    playButton->setMinimumSize(1, 1);
    stopButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    stopButton->setMinimumSize(1, 1);
    nextButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    nextButton->setMinimumSize(1, 1);
    previousButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    previousButton->setMinimumSize(1, 1);
    muteButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    muteButton->setMinimumSize(1, 1);

    openButton = new QToolButton(this);
    openButton->setIcon(style()->standardIcon(QStyle::SP_DirOpenIcon));
    openButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    openButton->setMinimumSize(1, 1);
    connect(openButton, SIGNAL(clicked()), this, SIGNAL(open()));

    hideWindowButton = new QToolButton(this);
    hideWindowButton->setIcon(style()->standardIcon(QStyle::SP_DirHomeIcon));
    hideWindowButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    hideWindowButton->setMinimumSize(1, 1);
    connect(hideWindowButton, SIGNAL(clicked()), this, SIGNAL(hideWindow()));

    playListButton = new QToolButton(this);
    playListButton->setIcon(style()->standardIcon(QStyle::SP_FileDialogDetailedView));
    playListButton->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Maximum);
    playListButton->setMinimumSize(1, 1);
    connect(playListButton, SIGNAL(clicked(bool)), this, SIGNAL(openPlayList()));

#endif

    QBoxLayout *layout = new QHBoxLayout;
    layout->setMargin(0);
    layout->addWidget(stopButton);
    layout->addWidget(previousButton);
    layout->addWidget(playButton);
    layout->addWidget(nextButton);
    layout->addWidget(muteButton);
#ifdef Q_OS_SYMBIAN
    layout->addWidget(openButton);
    layout->addWidget(playListButton);
    layout->addWidget(hideWindowButton);
#else
    if (volumeSlider)
        layout->addWidget(volumeSlider);

    if (rateBox)
        layout->addWidget(rateBox);
#endif
    setLayout(layout);
}

QMediaPlayer::State PlayerControls::state() const
{
    return playerState;
}

void PlayerControls::setState(QMediaPlayer::State state)
{
    if (state != playerState) {
        playerState = state;

        switch (state) {
        case QMediaPlayer::StoppedState:
            stopButton->setEnabled(false);
            playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
            break;
        case QMediaPlayer::PlayingState:
            stopButton->setEnabled(true);
            playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPause));
            break;
        case QMediaPlayer::PausedState:
            stopButton->setEnabled(true);
            playButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));
            break;
        }
    }
}

int PlayerControls::volume() const
{
#ifdef Q_OS_SYMBIAN
    return 0;
#else
    return volumeSlider ? volumeSlider->value() : 0;
#endif
}

void PlayerControls::setVolume(int volume)
{
#ifndef Q_OS_SYMBIAN
    if (volumeSlider)
        volumeSlider->setValue(volume);
#endif
}

bool PlayerControls::isMuted() const
{
    return playerMuted;
}

void PlayerControls::setMuted(bool muted)
{
    if (muted != playerMuted) {
        playerMuted = muted;

        muteButton->setIcon(style()->standardIcon(muted
                ? QStyle::SP_MediaVolumeMuted
                : QStyle::SP_MediaVolume));
    }
}

void PlayerControls::playClicked()
{
    switch (playerState) {
    case QMediaPlayer::StoppedState:
    case QMediaPlayer::PausedState:
        emit play();
        break;
    case QMediaPlayer::PlayingState:
        emit pause();
        break;
    }
}

void PlayerControls::muteClicked()
{
    emit changeMuting(!playerMuted);
}

qreal PlayerControls::playbackRate() const
{
#ifdef Q_OS_SYMBIAN
    return 0;
#else
    return rateBox->itemData(rateBox->currentIndex()).toDouble();
#endif
}

void PlayerControls::setPlaybackRate(float rate)
{
#ifndef Q_OS_SYMBIAN
    for (int i=0; i<rateBox->count(); i++) {
        if (qFuzzyCompare(rate, float(rateBox->itemData(i).toDouble()))) {
            rateBox->setCurrentIndex(i);
            return;
        }
    }

    rateBox->addItem( QString("%1x").arg(rate), QVariant(rate));
    rateBox->setCurrentIndex(rateBox->count()-1);
#endif
}

void PlayerControls::updateRate()
{
#ifndef Q_OS_SYMBIAN
    emit changeRate(playbackRate());
#endif
}
