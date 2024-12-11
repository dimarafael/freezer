#include "processitem.h"

ProcessItem::ProcessItem(){
    m_productName = "";
    m_state = 0;
    m_currentTemperature = 0;
    m_minutesMin = 0;
    m_minutesMax = 0;
    m_minutesCurrent = 0;
}

QString ProcessItem::productName() const
{
    return m_productName;
}

void ProcessItem::setProductName(const QString &newProductName)
{
    m_productName = newProductName;
}

int ProcessItem::state() const
{
    return m_state;
}

void ProcessItem::setState(int newState)
{
    m_state = newState;
}

float ProcessItem::currentTemperature() const
{
    return m_currentTemperature;
}

void ProcessItem::setCurrentTemperature(float newCurrentTemperature)
{
    m_currentTemperature = newCurrentTemperature;
}

int ProcessItem::minutesMin() const
{
    return m_minutesMin;
}

void ProcessItem::setMinutesMin(int newMinutesMin)
{
    m_minutesMin = newMinutesMin;
}

int ProcessItem::minutesMax() const
{
    return m_minutesMax;
}

void ProcessItem::setMinutesMax(int newMinutesMax)
{
    m_minutesMax = newMinutesMax;
}

int ProcessItem::minutesCurrent() const
{
    return m_minutesCurrent;
}

void ProcessItem::setMinutesCurrent(int newMinutesCurrent)
{
    m_minutesCurrent = newMinutesCurrent;
}

QDateTime ProcessItem::startDateTime() const
{
    return m_startDateTime;
}

void ProcessItem::setStartDateTime(const QDateTime &newStartDateTime)
{
    m_startDateTime = newStartDateTime;
}

float ProcessItem::startTemperature() const
{
    return m_startTemperature;
}

void ProcessItem::setStartTemperature(float newStartTemperature)
{
    m_startTemperature = newStartTemperature;
}

