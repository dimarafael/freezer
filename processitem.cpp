#include "processitem.h"

ProcessItem::ProcessItem(){
    m_productName = "";
    m_loaded = false;
    m_currentTimer = QTime::currentTime();
    m_timerSetpointMin = QTime::currentTime();
    m_timerSetpointMax = QTime::currentTime();
    m_currentTemperature = 0;
}

QString ProcessItem::productName() const
{
    return m_productName;
}

void ProcessItem::setProductName(const QString &newProductName)
{
    m_productName = newProductName;
}

bool ProcessItem::loaded() const
{
    return m_loaded;
}

void ProcessItem::setLoaded(bool newLoaded)
{
    m_loaded = newLoaded;
}

QTime ProcessItem::currentTimer() const
{
    return m_currentTimer;
}

void ProcessItem::setCurrentTimer(const QTime &newCurrentTimer)
{
    m_currentTimer = newCurrentTimer;
}

QTime ProcessItem::timerSetpointMin() const
{
    return m_timerSetpointMin;
}

void ProcessItem::setTimerSetpointMin(const QTime &newTimerSetpointMin)
{
    m_timerSetpointMin = newTimerSetpointMin;
}

QTime ProcessItem::timerSetpointMax() const
{
    return m_timerSetpointMax;
}

void ProcessItem::setTimerSetpointMax(const QTime &newTimerSetpointMax)
{
    m_timerSetpointMax = newTimerSetpointMax;
}

float ProcessItem::currentTemperature() const
{
    return m_currentTemperature;
}

void ProcessItem::setCurrentTemperature(float newCurrentTemperature)
{
    m_currentTemperature = newCurrentTemperature;
}
