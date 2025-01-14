#include "dbmanager.h"

DBManager::DBManager()
{}

DBManager::~DBManager()
{
    if(db.isOpen()){
        db.close();
    }
    reconnectTimer->deleteLater();
}

void DBManager::run()
{
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("10.0.10.64");
    db.setDatabaseName("iiot");
    db.setUserName("iiot");
    db.setPassword("iiot");
    db.setConnectOptions("MYSQL_OPT_CONNECT_TIMEOUT=3;MYSQL_OPT_READ_TIMEOUT=3;MYSQL_OPT_WRITE_TIMEOUT=3");

    currentConnectionState = false;
    checkConnection();

    reconnectTimer = new QTimer(this);
    reconnectTimer->setInterval(5000);
    reconnectTimer->setSingleShot(false);

    connect(reconnectTimer, &QTimer::timeout, this, &DBManager::checkConnection);
    reconnectTimer->start();
}

bool DBManager::isConnected() const
{
    return db.isOpen() && db.isValid() && currentConnectionState;
}

void DBManager::connectToDatabase()
{
    bool connected = db.open();

    if (connected != currentConnectionState) {
        currentConnectionState = connected;
        emit dbConnected(connected);

        if (connected) {
            qDebug() << "Connected to database!";
        } else {
            qWarning() << "Failed to connect to database:" << db.lastError().text();
        }
    }
}

void DBManager::checkConnection()
{
    if (isConnected()) {
        return;
    } else {
        emit dbConnected(false);
        connectToDatabase();
    }
}

void DBManager::addData(int place, bool occupied, const QString &name, float startTemperature, QDateTime startDateTime)
{
    if (!isConnected()) {
        qWarning() << "Database is not open!";
        return;
    }

    QSqlQuery query;
    query.prepare(R"(
            INSERT INTO freezer (place, occupied, name, startTemp, startDateTime)
            VALUES (:place, :occupied, :name, :startTemp, :startDateTime)
        )");
    query.bindValue(":place", place);
    query.bindValue(":occupied", occupied);
    query.bindValue(":name", name.isEmpty() ? QVariant(QMetaType(QMetaType::QString)) : name); // if empty string send NULL
    query.bindValue(":startTemp", startTemperature);
    query.bindValue(":startDateTime", startDateTime);

    if (!query.exec()) {
        qWarning() << "Failed to insert data:" << query.lastError().text();
        emit dbConnected(false);
        currentConnectionState = false;
    }
}

