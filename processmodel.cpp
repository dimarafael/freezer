#include "processmodel.h"

ProcessModel::ProcessModel(QObject *parent)
    :QAbstractListModel{parent}
{
    m_temperature = 0;
    m_sensorStatus = 0;

    for(int i =0; i < PLACES_QTY; i++){
        m_processList.append(ProcessItem());
    }

    m_timerCalculateProcess = new QTimer(this);
    m_timerCalculateProcess->setInterval(10000);
    connect(m_timerCalculateProcess, &QTimer::timeout, this, &ProcessModel::calculateProcess);
    m_timerCalculateProcess->start();

    // m_processList[0].setProductName("Test product 1");
    // m_processList[0].setState(1);
    // m_processList[0].setCurrentTemperature(28.9);
    // m_processList[0].setMinutesMin(28);
    // m_processList[0].setMinutesMax(32);
    // m_processList[0].setMinutesCurrent(23);
    // m_processList[0].setStartDateTime(QDateTime::currentDateTime());
    // m_processList[0].setStartTemperature(30);

    // m_processList[1].setProductName("Test product 2");
    // m_processList[1].setState(2);
    // m_processList[1].setCurrentTemperature(1.4);
    // m_processList[1].setMinutesMin(28);
    // m_processList[1].setMinutesMax(32);
    // m_processList[1].setMinutesCurrent(31);
    // m_processList[1].setStartDateTime(QDateTime::currentDateTime());
    // m_processList[0].setStartTemperature(30);

    // m_processList[2].setProductName("Test product 3");
    // m_processList[2].setState(3);
    // m_processList[2].setCurrentTemperature(-0.3);
    // m_processList[2].setMinutesMin(28);
    // m_processList[2].setMinutesMax(32);
    // m_processList[2].setMinutesCurrent(37);
    // m_processList[2].setStartDateTime(QDateTime::currentDateTime());
    // m_processList[0].setStartTemperature(30);
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

void ProcessModel::startProcess(int index, QString productName)
{
    beginResetModel();
    m_processList[index].setState(1);
    m_processList[index].setProductName(productName);
    m_processList[index].setMinutesCurrent(0);
    m_processList[index].setMinutesMin(calculateRequiredMinutes(temperature(), 1.5));
    m_processList[index].setMinutesMax(calculateRequiredMinutes(temperature(), 0.5));
    m_processList[index].setCurrentTemperature(temperature());
    m_processList[index].setStartTemperature(temperature());
    m_processList[index].setStartDateTime(QDateTime::currentDateTime());
    endResetModel();
}

void ProcessModel::dataReady(float sensorTemperature, int status)
{
    setTemperature(sensorTemperature);
    setSensorStatus(status);
    setMinutesRequired(calculateRequiredMinutes(temperature(), 1.5));
}

void ProcessModel::calculateProcess()
{
    qDebug() << "calculateProcess";
    beginResetModel();
    for(int i =0; i < PLACES_QTY; i++){
        int minutesInProcess = 0;
        if (m_processList[i].state() > 0){
            std::chrono::milliseconds msInProcess = QDateTime::currentDateTime() - m_processList[i].startDateTime();
            int intMsInProcess = msInProcess.count();
            qDebug() << "intMsInProcess=" << intMsInProcess;
            minutesInProcess = std::chrono::duration_cast<std::chrono::minutes>(QDateTime::currentDateTime() - m_processList[i].startDateTime()).count();
            qDebug() << "Place: " << i << " minutesInProcess=" << minutesInProcess;
            m_processList[i].setCurrentTemperature(calculateExpextedTemperature(m_processList[i].startTemperature() ,minutesInProcess));

            if (minutesInProcess > m_processList[i].minutesMin() && minutesInProcess <= m_processList[i].minutesMax()) {
                // status ready
                m_processList[i].setState(2);
                m_processList[i].setMinutesCurrent(minutesInProcess - m_processList[i].minutesMin());
            } else if (minutesInProcess > m_processList[i].minutesMax()){
                // status overcooled
                m_processList[i].setState(3);
                m_processList[i].setMinutesCurrent(minutesInProcess - m_processList[i].minutesMax());
            } else{
                // status cooling
                m_processList[i].setState(1);
                m_processList[i].setMinutesCurrent(minutesInProcess);
            }
        }
    }
    endResetModel();
}

int ProcessModel::calculateRequiredMinutes(float startTemperature, float targetTemperature)
{
    return 7 - floor(targetTemperature * 2); // ?????????????????????????????
}

float ProcessModel::calculateExpextedTemperature(float startTemperature, int minutes)
{
    return 12.3; // ?????????????????????????????
}

int ProcessModel::minutesRequired() const
{
    return m_minutesRequired;
}

void ProcessModel::setMinutesRequired(int newMinutesRequired)
{
    if (m_minutesRequired == newMinutesRequired)
        return;
    m_minutesRequired = newMinutesRequired;
    emit minutesRequiredChanged();
}
