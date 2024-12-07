#ifndef PROCESSITEM_H
#define PROCESSITEM_H

#include <QString>
#include <QTime>

class ProcessItem
{
public:
    ProcessItem();

    QString productName() const;
    void setProductName(const QString &newProductName);

    bool loaded() const;
    void setLoaded(bool newLoaded);

    QTime currentTimer() const;
    void setCurrentTimer(const QTime &newCurrentTimer);

    QTime timerSetpointMin() const;
    void setTimerSetpointMin(const QTime &newTimerSetpointMin);

    QTime timerSetpointMax() const;
    void setTimerSetpointMax(const QTime &newTimerSetpointMax);

    float currentTemperature() const;
    void setCurrentTemperature(float newCurrentTemperature);

private:
    QString m_productName;
    bool m_loaded;
    QTime m_currentTimer;
    QTime m_timerSetpointMin;
    QTime m_timerSetpointMax;
    float m_currentTemperature;
};

#endif // PROCESSITEM_H
