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


    int state() const;
    void setState(int newState);

    float currentTemperature() const;
    void setCurrentTemperature(float newCurrentTemperature);

    int minutesMin() const;
    void setMinutesMin(int newMinutesMin);

    int minutesMax() const;
    void setMinutesMax(int newMinutesMax);

    int minutesCurrent() const;
    void setMinutesCurrent(int newMinutesCurrent);

private:
    QString m_productName;
    int m_state; //0 empty, 1 cooling, 2 ready, 3 overcooled
    float m_currentTemperature;
    int m_minutesMin;
    int m_minutesMax;
    int m_minutesCurrent;
};

#endif // PROCESSITEM_H
