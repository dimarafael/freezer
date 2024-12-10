#ifndef PROCESSMODEL_H
#define PROCESSMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include "processitem.h"

class ProcessModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(float temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged FINAL)
    Q_PROPERTY(int sensorStatus READ sensorStatus WRITE setSensorStatus NOTIFY sensorStatusChanged FINAL)
public:
    enum Role{
        ProductNameRole = Qt::UserRole + 1,
        StateRole = Qt::UserRole + 2,
        TemperatureRole = Qt::UserRole + 3,
        MinutesMinRole = Qt::UserRole + 4,
        MinutesMaxRole = Qt::UserRole + 5,
        MinutesCurrentRole = Qt::UserRole + 6
    };
    explicit ProcessModel(QObject *parent = nullptr);

public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

    float temperature() const;
    void setTemperature(float newTemperature);

    int sensorStatus() const;
    void setSensorStatus(int newSensorStatus);
public slots:
    void dataReady(float temperature, int status); // 0 - ok, 1 - module offline, 2 - sensor not connected
signals:
    void temperatureChanged();

    void sensorStatusChanged();

private:
    QList<ProcessItem> m_processList;
    float m_temperature;
    int m_sensorStatus; // 0 - ok, 1 - module offline, 2 - sensor not connected
};

#endif // PROCESSMODEL_H
