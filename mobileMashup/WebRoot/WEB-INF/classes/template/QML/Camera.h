#ifndef CAMERA_H
#define CAMERA_H
#include <QtGui>

 // Multimedia API in QtMobility API
 // Unlike the other APIs in Qt Mobility,
 // the Multimedia API is not in the QtMobility namespace "QTM_USE_NAMESPACE"
 #include <QCamera>
 #include <QCameraImageCapture>

 // QtMobility API
 #include <QSystemScreenSaver>
 QTM_USE_NAMESPACE

 #include <QAbstractVideoSurface>
 #include <QVideoRendererControl>
 #include <QVideoSurfaceFormat>

 /*****************************************************************************
 * MyVideoSurface
 */
 class VideoIF
 {
 public:
     virtual void updateVideo() = 0;
 };
 class MyVideoSurface: public QAbstractVideoSurface
 {
 Q_OBJECT

 public:
     MyVideoSurface(QWidget* widget, VideoIF* target, QObject * parent = 0);
     ~MyVideoSurface();

     bool start(const QVideoSurfaceFormat &format);

     bool present(const QVideoFrame &frame);

     QList<QVideoFrame::PixelFormat> supportedPixelFormats(
                 QAbstractVideoBuffer::HandleType handleType = QAbstractVideoBuffer::NoHandle) const;

     void paint(QPainter*);

 private:
     QWidget* m_targetWidget;
     VideoIF* m_target;
     QVideoFrame m_frame;
     QImage::Format m_imageFormat;
     QVideoSurfaceFormat m_videoFormat;
 };

 /*****************************************************************************
 * CameraExample
 */
 class Message;
 class Button;
 class CameraExample: public QMainWindow, public VideoIF
 {
 Q_OBJECT

 public:
     CameraExample(QWidget *parent = 0);
     ~CameraExample();

     void paintEvent(QPaintEvent*);
     void mousePressEvent(QMouseEvent *);

     void updateVideo();
     Q_INVOKABLE QString getBinary();

     QByteArray imageData;

 public slots:
     void enableCamera();
     void lockStatusChanged(QCamera::LockStatus status, QCamera::LockChangeReason reason);
     void searchAndLock();
     void captureImage();
     void imageCaptured(int id, const QImage &preview);
     void error(QCamera::Error);

 private:
     QWidget*                m_videoWidget;
     QCamera*                m_camera;
     QCameraImageCapture*    m_stillImageCapture;

     QStackedWidget*         m_stackedWidget;
     Button*                 m_exit;
     Button*                 m_cameraBtn;
     QImage                  m_capturedImage;
     QString                 m_imageName;
     QString                 m_focusMessage;
     bool                    m_focusing;

     bool                    pictureCaptured;
     bool                    showViewFinder;
     MyVideoSurface*         m_myVideoSurface;
     QSystemScreenSaver*     m_systemScreenSaver;
 };
#endif // CAMERA_H
