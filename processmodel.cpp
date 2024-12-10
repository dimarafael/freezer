#include "processmodel.h"

ProcessModel::ProcessModel(QObject *parent)
    :QAbstractListModel{parent}
{
    m_temperature = 0;
    m_sensorStatus = 0;

    for(int i =0; i < 24; i++){
        m_processList.append(ProcessItem());
    }

    m_processList[0].setProductName("Test product 1");
    m_processList[0].setState(1);
    m_processList[0].setCurrentTemperature(28.9);
    m_processList[0].setMinutesMin(28);
    m_processList[0].setMinutesMax(32);
    m_processList[0].setMinutesCurrent(23);

    m_processList[1].setProductName("Test product 2");
    m_processList[1].setState(2);
    m_processList[1].setCurrentTemperature(1.4);
    m_processList[1].setMinutesMin(28);
    m_processList[1].setMinutesMax(32);
    m_processList[1].setMinutesCurrent(31);

    m_processList[2].setProductName("Test product 3");
    m_processList[2].setState(3);
    m_processList[2].setCurrentTemperature(-0.3);
    m_processList[2].setMinutesMin(28);
    m_processList[2].setMinutesMax(32);
    m_processList[2].setMinutesCurrent(37);
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
        case StateRole:
            return processItem.state();
        case TemperatureRole:
            return processItem.currentTemperature();
        case MinutesMinRole:
            return processItem.minutesMin();
        case MinutesMaxRole:
            return processItem.minutesMax();
        case MinutesCurrentRole:
            return processItem.minutesCurrent();
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
    names[StateRole] = "stage";
    names[TemperatureRole] = "temperature";
    names[MinutesMinRole] = "minutesMin";
    names[MinutesMaxRole] = "minutesMax";
    names[MinutesCurrentRole] = "minutesCurrent";
    return names;
}

float ProcessModel::temperature() const
{
    return m_temperature;
}

void ProcessModel::setTemperature(float newTemperature)
{
    if (qFuzzyCompare(m_temperature, newTemperature))
        return;
    m_temperature = newTemperature;
    emit temperatureChanged();
}

int ProcessModel::sensorStatus() const
{
    return m_sensorStatus;
}

void ProcessModel::setSensorStatus(int newSensorStatus)
{
    if (m_sensorStatus == newSensorStatus)
        return;
    m_sensorStatus = newSensorStatus;
    emit sensorStatusChanged();
}

void ProcessModel::stopProcess(int index)
{
    beginResetModel();
    m_processList[index].setState(0);
    endResetModel();
}

void ProcessModel::dataReady(float temperature, int status)
{
    setTemperature(temperature);
    setSensorStatus(status);
}
