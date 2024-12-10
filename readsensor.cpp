#include "readsensor.h"

ReadSensor::ReadSensor()
{}

ReadSensor::~ReadSensor()
{
    m_timer->deleteLater();
    m_manager->deleteLater();
    m_networkTimeoutTimer->deleteLater();
}

void ReadSensor::run()
{
    m_manager = new QNetworkAccessManager(this);

    connect(m_manager, &QNetworkAccessManager::finished, this, &ReadSensor::handleReply);

    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &ReadSensor::readData);
    m_timer->start();

    m_networkTimeoutTimer = new QTimer(this);
    m_networkTimeoutTimer->setSingleShot(true);
    connect(m_networkTimeoutTimer, &QTimer::timeout, this, &ReadSensor::networkTimeout);
}

void ReadSensor::networkTimeout(){
    emit dataReady(0, 1); // 1 - module offline
    qWarning() << "Sensor is offline";
}

void ReadSensor::readData()
{
    qDebug() << "Reading sensor ...";
    if(!m_networkTimeoutTimer->isActive()){
        m_networkTimeoutTimer->start(2000);
        m_manager->get(QNetworkRequest(QUrl("http://10.0.99.5/iolinkmaster/port[4]/iolinkdevice/pdin/getdata")));
    }
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
        emit dataReady(0, 1); // 1 - module offline
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
                    m_networkTimeoutTimer->stop();
                    emit dataReady((static_cast<float>(intValue))/10, 0); // 0 - ok
                } else {
                    qWarning() << "Failed to convert hex value to integer:" << hexValue;
                    emit dataReady(0, 2); // 2 - sensor not connected
                }
            }
        } else{
            qWarning() << "Invalid JSON object \"data\"";
            emit dataReady(0, 2); // 2 - sensor not connected
        }


    } else {
        qWarning() << "Invalid JSON response";
        emit dataReady(0, 2); // 2 - sensor not connected
    }

    reply->deleteLater();
}
