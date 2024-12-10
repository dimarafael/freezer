#ifndef READSENSOR_H
#define READSENSOR_H

#include <QObject>
#include <QTimer>
#include <QDebug>

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkAccessManager>

class ReadSensor : public QObject
{
    Q_OBJECT
public:
    // explicit ReadSensor(QObject *parent = nullptr);
    ReadSensor();
    ~ReadSensor();

signals:
    void dataReady(float temperature, int status); // 0 - ok, 1 - module offline, 2 - sensor not connected

public slots:
    void run(); // for starting thread

private slots:
    void readData(); // connect to timeout of timer
    void handleReply(QNetworkReply* reply);
    void networkTimeout();

private:
    QTimer *m_timer;
    QTimer *m_networkTimeoutTimer;
    QNetworkAccessManager *m_manager;
};

#endif // READSENSOR_H
