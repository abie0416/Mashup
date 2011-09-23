#include "videowidget.h"

#include <QtGui>

VideoWidget::VideoWidget(QWidget *parent)
    : QVideoWidget(parent)
{
    setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Ignored);

    QPalette p = palette();
    p.setColor(QPalette::Window, Qt::black);
    setPalette(p);

    setAttribute(Qt::WA_OpaquePaintEvent);
}

void VideoWidget::keyPressEvent(QKeyEvent *event)
{
#ifdef Q_OS_SYMBIAN
    if (isFullScreen())
        setFullScreen(false);
#endif

    if (event->key() == Qt::Key_Escape && isFullScreen()) {
        showNormal();

        event->accept();
    } else if (event->key() == Qt::Key_Enter && event->modifiers() & Qt::Key_Alt) {
        setFullScreen(!isFullScreen());

        event->accept();
    } else {
        QVideoWidget::keyPressEvent(event);
    }
}

void VideoWidget::mouseDoubleClickEvent(QMouseEvent *event)
{
    setFullScreen(!isFullScreen());

    event->accept();
}

void VideoWidget::mousePressEvent(QMouseEvent *event)
{
#ifdef Q_WS_MAEMO_5
    if (isFullScreen())
        setFullScreen(false);

    event->accept();
#else
    QVideoWidget::mousePressEvent(event);
#endif
}
