#ifndef VIDEOWIDGET_H
#define VIDEOWIDGET_H

#include <qvideowidget.h>

QT_USE_NAMESPACE

class VideoWidget : public QVideoWidget
{
    Q_OBJECT
public:
    VideoWidget(QWidget *parent = 0);

protected:
    void keyPressEvent(QKeyEvent *event);
    void mouseDoubleClickEvent(QMouseEvent *event);
    void mousePressEvent(QMouseEvent *event);
};

#endif
