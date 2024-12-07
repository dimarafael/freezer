#ifndef PROCESSMODEL_H
#define PROCESSMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "processitem.h"

class ProcessModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Role{
        ProductNameRole = Qt::UserRole + 1,
        ProductLoadedRole = Qt::UserRole + 2,
        CurrentTimerRole = Qt::UserRole + 3,
        TimerSetpointMinRole = Qt::UserRole + 4,
        TimerSetpointMaxRole = Qt::UserRole + 5,
        CurrentTemperatureRole = Qt::UserRole + 6
    };
    explicit ProcessModel(QObject *parent = nullptr);

public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QList<ProcessItem> m_processList;
};

#endif // PROCESSMODEL_H
