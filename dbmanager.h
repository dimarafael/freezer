#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QTimer>

// QMYSQL driver
// https://github.com/thecodemonkey86/qt_mysql_driver/releases

class DBManager : public QObject
{
    Q_OBJECT
public:
    DBManager();
    ~DBManager();

    bool isConnected() const;
    void connectToDatabase();

public slots:
    void run(); // for starting thread
    void addData(int place, bool occupied, const QString &name, float startTemperature, QDateTime startDateTime);

signals:
    void dbConnected(bool state);

private:
    QSqlDatabase db;
    QTimer *reconnectTimer;
    bool currentConnectionState;

    void checkConnection();
};

#endif // DBMANAGER_H
