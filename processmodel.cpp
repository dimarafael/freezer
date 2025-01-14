#include "processmodel.h"

ProcessModel::ProcessModel(QObject *parent)
    :QAbstractListModel{parent}
{
    m_temperature = 0;
    m_sensorStatus = 0;

    for(int i =0; i < PLACES_QTY; i++){
        m_processList.append(ProcessItem());
    }

    readFromSettings();

    m_timerCalculateProcess = new QTimer(this);
    m_timerCalculateProcess->setInterval(10000);
    connect(m_timerCalculateProcess, &QTimer::timeout, this, &ProcessModel::calculateProcess);
    m_timerCalculateProcess->start();

    // connect(dbManager, &DBManager::dbConnected, this, &ProcessModel::setDbConnected);
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
    writeToSettings();
    emit addDataToDB(index,false,"",0,QDateTime::currentDateTime());
}

void ProcessModel::startProcess(int index, QString productName)
{
    beginResetModel();
    m_processList[index].setState(1);
    m_processList[index].setProductName(productName);
    m_processList[index].setMinutesCurrent(0);
    // m_processList[index].setMinutesMin(calculateRequiredMinutes(temperature(), 1.5));
    // m_processList[index].setMinutesMax(calculateRequiredMinutes(temperature(), 0.5));
    m_processList[index].setMinutesMin(120); // change to function !!!!!!!!!!!!!!!!!!!!
    m_processList[index].setMinutesMax(240); // change to function !!!!!!!!!!!!!!!!!!!!
    m_processList[index].setCurrentTemperature(temperature());
    m_processList[index].setStartTemperature(temperature());
    m_processList[index].setStartDateTime(QDateTime::currentDateTime());
    endResetModel();
    writeToSettings();
    emit addDataToDB(index,true,productName,temperature(),QDateTime::currentDateTime());
}

void ProcessModel::dataReady(float sensorTemperature, int status)
{
    setTemperature(sensorTemperature);
    setSensorStatus(status);
    setMinutesRequired(120); // change to function !!!!!!!!!!!!!!!!!!!!
}

void ProcessModel::calculateProcess()
{
    // qDebug() << "calculateProcess";
    beginResetModel();
    for(int i =0; i < PLACES_QTY; i++){
        int minutesInProcess = 0;
        if (m_processList[i].state() > 0){
            minutesInProcess = std::chrono::duration_cast<std::chrono::minutes>(QDateTime::currentDateTime() - m_processList[i].startDateTime()).count();
            // qDebug() << "Place: " << i << " minutesInProcess=" << minutesInProcess;
            m_processList[i].setMinutesCurrent(minutesInProcess);
            m_processList[i].setCurrentTemperature(calculateExpextedTemperature(m_processList[i].startTemperature() ,minutesInProcess));

            if (minutesInProcess >= m_processList[i].minutesMin() && minutesInProcess <= m_processList[i].minutesMax()) {
                // status ready
                m_processList[i].setState(2);
            } else if (minutesInProcess > m_processList[i].minutesMax()){
                // status overcooled
                m_processList[i].setState(3);
            } else{
                // status cooling
                m_processList[i].setState(1);
            }
        }
    }
    // qDebug() << "-------------------";
    endResetModel();
}

int ProcessModel::calculateRequiredMinutes(float startTemperature, float targetTemperature)
{
    return 7 - floor(targetTemperature * 2); // ?????????????????????????????
}

float ProcessModel::calculateExpextedTemperature(float startTemperature, int minutes)
{
    return 0; // ?????????????????????????????
}

void ProcessModel::readFromSettings()
{
    int size = m_settings.beginReadArray("process");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        m_processList[i].setProductName(m_settings.value("name","").toString());
        m_processList[i].setState(m_settings.value("state").toInt());
        m_processList[i].setMinutesMin(m_settings.value("minutesMin").toInt());
        m_processList[i].setMinutesMax(m_settings.value("minutesMax").toInt());
        m_processList[i].setStartDateTime(QDateTime::fromSecsSinceEpoch(m_settings.value("startDateTime").toLongLong()));
        m_processList[i].setStartTemperature(m_settings.value("startTemperature").toFloat());
    }
    m_settings.endArray();
}

void ProcessModel::writeToSettings()
{
    m_settings.beginWriteArray("process");
    for(qsizetype i = 0; i < m_processList.size(); ++i){
        m_settings.setArrayIndex(i);
        m_settings.setValue("name", m_processList.at(i).productName());
        m_settings.setValue("state" ,m_processList.at(i).state());
        m_settings.setValue("minutesMin", m_processList.at(i).minutesMin());
        m_settings.setValue("minutesMax", m_processList.at(i).minutesMax());
        m_settings.setValue("startDateTime", m_processList.at(i).startDateTime().toSecsSinceEpoch());
        m_settings.setValue("startTemperature", m_processList.at(i).startTemperature());
    }
    m_settings.endArray();
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

bool ProcessModel::dbConnected() const
{
    return m_dbConnected;
}

void ProcessModel::setDbConnected(bool newDbConnected)
{
    if (m_dbConnected == newDbConnected)
        return;
    m_dbConnected = newDbConnected;
    emit dbConnectedChanged();
}
