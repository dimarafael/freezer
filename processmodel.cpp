#include "processmodel.h"

ProcessModel::ProcessModel(QObject *parent)
    :QAbstractListModel{parent}
{

}

int ProcessModel::rowCount(const QModelIndex &parent) const
{
    return m_processList.count();
}

QVariant ProcessModel::data(const QModelIndex &index, int role) const
{
    if (index.isValid() && index.row() >= 0 && index.row() <m_processList.count()){
        ProcessItem processItem = m_processList[index.row()];
        switch ((Role)role) {
        case ProductNameRole:
            return processItem.productName();
        case ProductLoadedRole:
            return processItem.loaded();
        case CurrentTimerRole:
            return processItem.currentTimer();
        case TimerSetpointMinRole:
            return processItem.timerSetpointMin();
        case TimerSetpointMaxRole:
            return processItem.timerSetpointMax();
        case CurrentTemperatureRole:
            return processItem.currentTemperature();
        default:
            return {};
        }
    }
    return {};
}

QHash<int, QByteArray> ProcessModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[ProductNameRole] = "productName";
    names[ProductLoadedRole] = "productLoaded";
    names[CurrentTimerRole] = "currentTimer";
    names[TimerSetpointMinRole] = "timerSetpointMin";
    names[TimerSetpointMaxRole] = "timerSetpointMax";
    names[CurrentTemperatureRole] = "currentTemperature";
    return names;
}
