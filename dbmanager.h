#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>

// QMYSQL driver
// https://github.com/thecodemonkey86/qt_mysql_driver/releases

class DBManager : public QObject
{
    Q_OBJECT
public:
    explicit DBManager(QObject *parent = nullptr);
    ~DBManager();

    bool addData(int place, bool occupied, const QString &name, float startTemperature, QDateTime startDateTime);

signals:

private:
    QSqlDatabase db;
};

#endif // DBMANAGER_H
