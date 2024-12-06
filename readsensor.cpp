#include "readsensor.h"

ReadSensor::ReadSensor()
{}

ReadSensor::~ReadSensor()
{
    m_timer->deleteLater();
    m_reply->deleteLater();
    m_manager->deleteLater();
}

void ReadSensor::run()
{
    m_manager = new QNetworkAccessManager(this);
    m_request = QNetworkRequest(QUrl("http://10.0.99.5/iolinkmaster/port[4]/iolinkdevice/pdin/getdata"));

    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &ReadSensor::readData);
    m_timer->start();
    // QObject::connect(reply, &QNetworkReply::finished, this, &ReadSensor::networkReplyFinished);
    // QObject::connect(reply, &QNetworkReply::finished, [reply]() {
    //     // read data
    //     QString ReplyText = reply->readAll();
    //     // qDebug() << ReplyText;
    //     // ask doc to parse it
    //     QJsonDocument doc = QJsonDocument::fromJson(ReplyText.toUtf8());
    //     // we know first element in file is object, to try to ask for such
    //     QJsonObject obj = doc.object();
    //     // ask object for value
    //     QJsonValue value = obj.value(QString("bdata"));
    //     qDebug() << "Sensor data is:" << value.toString();;
    //     reply->deleteLater(); // make sure to clean up
    // });
}

void ReadSensor::readData()
{
    qDebug() << "Reading sensor ...";
    m_reply = m_manager->get(m_request);
    QObject::connect(m_reply, &QNetworkReply::finished, this, &ReadSensor::networkReplyFinished);
    QObject::connect(m_reply, &QNetworkReply::errorOccurred,[](){
        qDebug() << "errorOccurred";
    });
}

void ReadSensor::networkReplyFinished()
{
    // read data
    QString ReplyText = m_reply->readAll();
    qDebug() << ReplyText;
    // ask doc to parse it
    QJsonDocument doc = QJsonDocument::fromJson(ReplyText.toUtf8());
    // we know first element in file is object, to try to ask for such
    QJsonObject obj = doc.object();
    // ask object for value
    QJsonValue value = obj.value(QString("data")).toObject().value(QString("value"));

    qDebug() << "Sensor data is:" << value.toString();
    m_reply->deleteLater(); // make sure to clean up
    bool bStatus = false;
    qDebug() << "Int=" << value.toString().toInt(&bStatus,16);
}
