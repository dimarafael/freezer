#include "dbmanager.h"

DBManager::DBManager(QObject *parent)
    : QObject{parent}
{
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("10.0.10.64");
    db.setDatabaseName("iiot");
    db.setUserName("iiot");
    db.setPassword("iiot");

    if (!db.open()) {
        qWarning() << "Failed to connect to the database:" << db.lastError().text();
    } else{
        qDebug() << "Database connected";
    }
}

DBManager::~DBManager()
{
    if(db.isOpen()){
        db.close();
    }
}

bool DBManager::addData(int place, bool occupied, const QString &name)
{
    if (!db.isOpen()) {
        qWarning() << "Database is not open!";
        return false;
    }

    QSqlQuery query;
    query.prepare(R"(
            INSERT INTO freezer (place, occupied, name)
            VALUES (:place, :occupied, :name)
        )");
    query.bindValue(":place", place);
    query.bindValue(":occupied", occupied);
    query.bindValue(":name", name.isEmpty() ? QVariant(QMetaType(QMetaType::QString)) : name); // if empty string send NULL

    if (!query.exec()) {
        qWarning() << "Failed to insert data:" << query.lastError().text();
        return false;
    }

    return true;
}
