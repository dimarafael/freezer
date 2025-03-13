#include "dbapi.h"

DbApi::DbApi(QObject *parent)
    : QObject{parent}
{}

void DbApi::run()
{
    networkManager = new QNetworkAccessManager(this);
}

void DbApi::postData(int place, bool occupied, const QString &name, float startTemperature, float weight)
{
    // QUrl url("http://10.0.10.64:1880/vedogaz/freezer/db/add");
    QUrl url("http://10.0.10.64:1880/vedogaz/freezer/db/add_test");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;
    json["place"] = place;
    json["occupied"] = occupied;
    json["name"] = name;
    json["startTemperature"] = startTemperature;
    json["weight"] = weight;

    QJsonDocument doc(json);

    QNetworkReply *reply = networkManager->post(request, doc.toJson());

    connect(reply, &QNetworkReply::finished, this, [reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            qDebug() << "Data posted successfully:" << reply->readAll();
        } else {
            qDebug() << "Failed to post data:" << reply->errorString();
        }
        reply->deleteLater();
    });
}
