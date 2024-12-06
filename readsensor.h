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

public slots:
    void run(); // for starting thread

private slots:
    void readData(); // connect to timeout of timer
    void networkReplyFinished();

private:
    QTimer *m_timer;
    QNetworkAccessManager *m_manager;
    QNetworkRequest m_request;
    QNetworkReply* m_reply;
};

#endif // READSENSOR_H
