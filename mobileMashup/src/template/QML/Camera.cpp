#include "Camera.h"
#include "button.h"
#include <QDebug>

/*****************************************************************************
* MyVideoSurface
*/
MyVideoSurface::MyVideoSurface(QWidget* widget, VideoIF* target, QObject* parent)
    : QAbstractVideoSurface(parent)
{
    m_targetWidget = widget;
    m_target = target;
    m_imageFormat = QImage::Format_Invalid;
}

MyVideoSurface::~MyVideoSurface()
{
}

bool MyVideoSurface::start(const QVideoSurfaceFormat &format)
{
    m_videoFormat = format;
    const QImage::Format imageFormat = QVideoFrame::imageFormatFromPixelFormat(format.pixelFormat());
    const QSize size = format.frameSize();

    if (imageFormat != QImage::Format_Invalid && !size.isEmpty()) {
        m_imageFormat = imageFormat;
        QAbstractVideoSurface::start(format);
        return true;
    } else {
        return false;
    }
}

bool MyVideoSurface::present(const QVideoFrame &frame)
{
    m_frame = frame;
    if (surfaceFormat().pixelFormat() != m_frame.pixelFormat() ||
            surfaceFormat().frameSize() != m_frame.size()) {
        stop();
        return false;
    } else {
        m_target->updateVideo();
        return true;
    }
}

void MyVideoSurface::paint(QPainter *painter)
 {
     if (m_frame.map(QAbstractVideoBuffer::ReadOnly)) {
         QImage image(
                 m_frame.bits(),
                 m_frame.width(),
                 m_frame.height(),
                 m_frame.bytesPerLine(),
                 m_imageFormat);

         QRect r = m_targetWidget->rect();
         QPoint centerPic((qAbs(r.size().width() - image.size().width())) / 2, (qAbs(
             r.size().height() - image.size().height())) / 2);

         if (!image.isNull()) {
            painter->drawImage(centerPic,image);
         }

         m_frame.unmap();
     }
 }

QList<QVideoFrame::PixelFormat> MyVideoSurface::supportedPixelFormats(
            QAbstractVideoBuffer::HandleType handleType) const
{
    if (handleType == QAbstractVideoBuffer::NoHandle) {
        return QList<QVideoFrame::PixelFormat>()
                << QVideoFrame::Format_RGB32
                << QVideoFrame::Format_ARGB32
                << QVideoFrame::Format_ARGB32_Premultiplied
                << QVideoFrame::Format_RGB565
                << QVideoFrame::Format_RGB555;
    } else {
        return QList<QVideoFrame::PixelFormat>();
    }
}

/*****************************************************************************
* CameraExample
*/
CameraExample::CameraExample(QWidget *parent) :
    QMainWindow(parent)
{
    setWindowTitle("QCameraExample");

    // Opitimizations for screen update and drawing qwidget
    setAutoFillBackground(false);

    // Prevent to screensaver to activate
    m_systemScreenSaver = new QSystemScreenSaver(this);
    m_systemScreenSaver->setScreenSaverInhibit();

    m_myVideoSurface = 0;
    pictureCaptured = false;
    showViewFinder = false;
    m_focusing = false;

    // Black background
    QPalette palette = this->palette();
    palette.setColor(QPalette::Background, Qt::black);
    setPalette(palette);

    // Main widget & layout
    QWidget* mainWidget = new QWidget(this);
    mainWidget->setPalette(palette);

    QHBoxLayout* hboxl = new QHBoxLayout;
    hboxl->setSpacing(0);
    hboxl->setMargin(0);

    // UI stack
    m_stackedWidget = new QStackedWidget();
    m_stackedWidget->setPalette(palette);

    // First widget to stack
    m_videoWidget = new QWidget();
    m_videoWidget->setPalette(palette);
    m_stackedWidget->addWidget(m_videoWidget);

    // Second widget to stack
    QWidget* secondWidget = new QWidget(this);
    secondWidget->setPalette(palette);
    m_stackedWidget->addWidget(secondWidget);
    m_stackedWidget->setCurrentIndex(0);

    hboxl->addWidget(m_stackedWidget);

    // Buttons
    QSize iconSize(80, 80);
    QVBoxLayout* vboxl = new QVBoxLayout;
    vboxl->setSpacing(0);
    vboxl->setMargin(0);

    // Camera button
    m_cameraBtn = new Button(this);
    QObject::connect(m_cameraBtn, SIGNAL(pressed()), this, SLOT(searchAndLock()));
    QPixmap p = QPixmap(":/images/camera.png");
    m_cameraBtn->setPixmap(p.scaled(iconSize, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    vboxl->addWidget(m_cameraBtn);
    vboxl->setAlignment(m_cameraBtn, Qt::AlignCenter);

    // Exit button
    m_exit = new Button(this);
    QObject::connect(m_exit, SIGNAL(pressed()), qApp, SLOT(quit()));
    p = QPixmap(":/images/exit.png");
    m_exit->setPixmap(p.scaled(iconSize, Qt::KeepAspectRatio, Qt::SmoothTransformation));
    vboxl->addWidget(m_exit);
    vboxl->setAlignment(m_exit, Qt::AlignHCenter | Qt::AlignTop);

    hboxl->addLayout(vboxl);
    mainWidget->setLayout(hboxl);

    setCentralWidget(mainWidget);

    // Enable camera after 1s, so that the application is started
    // and widget is created to landscape orientation
    QTimer::singleShot(1000,this,SLOT(enableCamera()));
}

CameraExample::~CameraExample()
{
if (m_myVideoSurface)
    m_myVideoSurface->stop();
    m_camera->stop();
    delete m_stackedWidget;
    delete m_stillImageCapture;
    delete m_camera;
}

void CameraExample::enableCamera()
{
    m_camera = new QCamera();
    m_camera->setCaptureMode(QCamera::CaptureStillImage);
    connect(m_camera, SIGNAL(error(QCamera::Error)), this, SLOT(error(QCamera::Error)));
    connect(m_camera, SIGNAL(lockStatusChanged(QCamera::LockStatus,QCamera::LockChangeReason)), this, SLOT(lockStatusChanged(QCamera::LockStatus,QCamera::LockChangeReason)));

    // Own video output drawing that shows camera view finder pictures
    QMediaService* ms = m_camera->service();
    QVideoRendererControl* vrc = ms->requestControl<QVideoRendererControl*>();
    m_myVideoSurface = new MyVideoSurface(this,this,this);
    vrc->setSurface(m_myVideoSurface);
    // Image capturer
    m_stillImageCapture = new QCameraImageCapture(m_camera);
    connect(m_stillImageCapture, SIGNAL(imageCaptured(int,QImage)), this, SLOT(imageCaptured(int,QImage)));

    // Start camera
    if (m_camera->state() == QCamera::ActiveState) {
        m_camera->stop();
    }
    m_videoWidget->show();
    m_camera->start();
    showViewFinder = true;
}

void CameraExample::mousePressEvent(QMouseEvent *event)
{
    QMainWindow::mousePressEvent(event);

    if (pictureCaptured) {
        // Starting view finder
        pictureCaptured = false;
        m_stackedWidget->setCurrentIndex(0);
        if (m_myVideoSurface) {
            showViewFinder = true;
        }
    }
}

void CameraExample::searchAndLock()
{
    m_focusing = false;
    m_focusMessage.clear();

    if (pictureCaptured) {
        // Starting view finder again
        pictureCaptured = false;
        m_stackedWidget->setCurrentIndex(0);
        if (m_myVideoSurface) {
            showViewFinder = true;
        }
    }
    else {
        // Search and lock picture (=focus)
        if (m_camera->supportedLocks() & QCamera::LockFocus) {
            m_focusing = true;
            m_focusMessage = "Focusing...";
            m_camera->searchAndLock(QCamera::LockFocus);
        } else {
        // No focus functionality, take picture right away
            captureImage();
        }
    }
}

void CameraExample::lockStatusChanged(QCamera::LockStatus status, QCamera::LockChangeReason reason)
{
    if (status == QCamera::Locked) {
        if (reason == QCamera::LockAcquired) {
            // Focus locked
            m_focusMessage.clear();
            m_focusing = false;
            // Capture new image
            captureImage();
            // Unlock camera
            m_camera->unlock();
        } else {
            if (m_focusing)
                m_focusMessage = "No focus, try again";
        }
    } else if (status == QCamera::Unlocked && m_focusing) {
        m_focusMessage = "No focus, try again";
    }
}

void CameraExample::captureImage()
{
    if (pictureCaptured) {
        // Starting view finder again
        pictureCaptured = false;
        m_stackedWidget->setCurrentIndex(0);
        showViewFinder = true;
    }
    else {
        // Capturing image
        showViewFinder = false;
        // Get picture location where to store captured images
        QString path(QDesktopServices::storageLocation(QDesktopServices::PicturesLocation));
        QDir dir(path);

        // Get next filename
        QStringList files = dir.entryList(QStringList() << "camera_*.jpg"); // c:/Data/Images/camera_2.jpg.
        int lastImage = 0;
        foreach ( QString fileName, files ) {
                int imgNumber = fileName.mid(7, fileName.size() - 11).toInt();
                lastImage = qMax(lastImage, imgNumber);
            }
        // Capture image
        if (m_stillImageCapture->isReadyForCapture()) {
            m_imageName = QString("camera_%1.jpg").arg(lastImage+1);
            m_stillImageCapture->capture(m_imageName);
        }
    }
}

void CameraExample::imageCaptured(int id, const QImage &preview)
{
    showViewFinder = false;
    m_focusing = false;

    // Image captured, show it to the user
    m_stackedWidget->setCurrentIndex(1);

    // Get picture location
    QString path(QDesktopServices::storageLocation(QDesktopServices::PicturesLocation));
    m_imageName.prepend(path + "/");

    m_capturedImage = preview;

    // Set suitable size to the image
    QSize s = m_videoWidget->size();
    s = s - QSize(20, 20);
    m_capturedImage = m_capturedImage.scaled(s, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    pictureCaptured = true;
    update();
}

void CameraExample::error(QCamera::Error e)
{
    switch (e) {
    case QCamera::NoError:
    {
        break;
    }
    case QCamera::CameraError:
    {
        QMessageBox::warning(this, "QCameraExample", "General Camera error");
        break;
    }
    case QCamera::InvalidRequestError:
    {
        QMessageBox::warning(this, "QCameraExample", "Camera invalid request error");
        break;
    }
    case QCamera::ServiceMissingError:
    {
        QMessageBox::warning(this, "QCameraExample", "Camera service missing error");
        break;
    }
    case QCamera::NotSupportedFeatureError :
    {
        QMessageBox::warning(this, "QCameraExample", "Camera not supported error");
        break;
    }
    };
}

void CameraExample::updateVideo()
{
    if (showViewFinder) {
        repaint();
    }
}

void CameraExample::paintEvent(QPaintEvent *event)
{
    //QMainWindow::paintEvent(event);

    QPainter painter(this);
    QRect r = this->rect();

    QFont font = painter.font();
    font.setPixelSize(20);
    painter.setFont(font);
    painter.setPen(Qt::white);

    if (showViewFinder && m_myVideoSurface && m_myVideoSurface->isActive()) {
        // Show view finder
        m_myVideoSurface->paint(&painter);

        // Paint focus message
        if (!m_focusMessage.isEmpty())
            painter.drawText(r, Qt::AlignCenter, m_focusMessage);

    } else {
        // Draw black
        painter.fillRect(event->rect(), palette().background());
        // Show captured image
        if (pictureCaptured) {
            // Paint captured image
            QPoint centerPic((qAbs(r.size().width() - m_capturedImage.size().width())) / 2, (qAbs(
                r.size().height() - m_capturedImage.size().height())) / 2);

            painter.drawImage(centerPic, m_capturedImage);

            // Paint filename
            //painter.drawText(r, Qt::AlignBottom | Qt::AlignCenter, m_imageName);
            getBinary();
        }
    }

}

 Q_INVOKABLE QString CameraExample::getBinary()
{
    QFile image("c:/Data/Images/camera_2.jpg");
    imageData = image.readLine();
    /*
    QImage image;
    bool loadImage = image.load("c:/Data/Images/camera_2.jpg");
    if(loadImage != false)
    {
        uchar c = image.bits()[0];
        std::count << c;
        c = image.bits()[1];
        std::count << c;
    }*/
}
