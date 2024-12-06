#include "readsensor.h"

ReadSensor::ReadSensor()
{}

ReadSensor::~ReadSensor()
{
    m_timer->deleteLater();
    // m_reply->deleteLater();
    m_manager->deleteLater();
}

void ReadSensor::run()
{
    m_manager = new QNetworkAccessManager(this);
    // m_request = QNetworkRequest(QUrl("http://10.0.99.5/iolinkmaster/port[4]/iolinkdevice/pdin/getdata"));

    connect(m_manager, &QNetworkAccessManager::finished, this, &ReadSensor::handleReply);

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
    // m_reply = m_manager->get(m_request);
    m_manager->get(QNetworkRequest(QUrl("http://10.0.99.5/iolinkmaster/port[4]/iolinkdevice/pdin/getdata")));
    // QObject::connect(m_reply, &QNetworkReply::finished, this, &ReadSensor::networkReplyFinished);
    // QObject::connect(m_reply, &QNetworkReply::errorOccurred,[](){
    //     qDebug() << "errorOccurred";
    // });
}

void ReadSensor::networkReplyFinished()
{
    // // read data
    // QString ReplyText = m_reply->readAll();
    // qDebug() << ReplyText;
    // // ask doc to parse it
    // QJsonDocument doc = QJsonDocument::fromJson(ReplyText.toUtf8());
    // // we know first element in file is object, to try to ask for such
    // QJsonObject obj = doc.object();
    // // ask object for value
    // QJsonValue value = obj.value(QString("data")).toObject().value(QString("value"));

    // qDebug() << "Sensor data is:" << value.toString();
    // m_reply->deleteLater(); // make sure to clean up
    // bool bStatus = false;
    // qDebug() << "Int=" << value.toString().toInt(&bStatus,16);
}

void ReadSensor::handleReply(QNetworkReply* reply)
{
    qDebug() << "handleReply";
    if (reply->error() != QNetworkReply::NoError) {
        if (reply->error() == QNetworkReply::HostNotFoundError ||
            reply->error() == QNetworkReply::ConnectionRefusedError ||
            reply->error() == QNetworkReply::TimeoutError) {
            qWarning() << "Device is offline or unreachable.";
        } else {
            qWarning() << "Network error:" << reply->errorString();
        }
        reply->deleteLater();
        return;
    }

    QString replyText = reply->readAll();
    // qDebug() << replyText;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(replyText.toUtf8());
    if (jsonDoc.isObject()) {
        QJsonObject jsonObj = jsonDoc.object();
        if (jsonObj.contains("data") && jsonObj["data"].isObject()) {
            QJsonObject dataObj = jsonObj["data"].toObject();
            if (dataObj.contains("value")) {
                QString hexValue = dataObj["value"].toString();
                bool ok = false;
                int intValue = hexValue.toInt(&ok, 16); // Convert hex string to integer
                if (ok) {
                    qDebug() << "Hex value:" << hexValue << "Integer value:" << intValue;
                } else {
                    qWarning() << "Failed to convert hex value to integer:" << hexValue;
                }
            }
        }


    } else {
        qWarning() << "Invalid JSON response";
    }

    reply->deleteLater();
}
