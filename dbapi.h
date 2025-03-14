#ifndef DBAPI_H
#define DBAPI_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QDateTime>
#include <QDebug>

class DbApi : public QObject
{
    Q_OBJECT
public:
    explicit DbApi(QObject *parent = nullptr);

public slots:
    void run(); // for starting thread
    void postData(int place, bool occupied, const QString &name, float startTemperature, float weight, int state);

signals:

private:
    QNetworkAccessManager *networkManager;
};

#endif // DBAPI_H
