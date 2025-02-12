#ifndef PROCESSMODEL_H
#define PROCESSMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QTimer>
#include <QSettings>
#include "processitem.h"

#define PLACES_QTY 24

class ProcessModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(float temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged FINAL)
    Q_PROPERTY(int sensorStatus READ sensorStatus WRITE setSensorStatus NOTIFY sensorStatusChanged FINAL)
    Q_PROPERTY(int minutesRequired READ minutesRequired WRITE setMinutesRequired NOTIFY minutesRequiredChanged FINAL)
    Q_PROPERTY(float weightCrate READ weightCrate WRITE setWeightCrate NOTIFY weightCrateChanged FINAL)
    Q_PROPERTY(float weightCart READ weightCart WRITE setWeightCart NOTIFY weightCartChanged FINAL)
    Q_PROPERTY(float sensorCorrection READ sensorCorrection WRITE setSensorCorrection NOTIFY sensorCorrectionChanged FINAL)

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

    Q_INVOKABLE void stopProcess(int index);
    Q_INVOKABLE void startProcess(int index, QString productName, float weight);

    int minutesRequired() const;
    void setMinutesRequired(int newMinutesRequired);

    float weightCrate() const;
    void setWeightCrate(float newWeightCrate);

    float weightCart() const;
    void setWeightCart(float newWeightCart);

    float sensorCorrection() const;
    void setSensorCorrection(float newSensorCorrection);

public slots:
    void dataReady(float sensorTemperature, int status); // 0 - ok, 1 - module offline, 2 - sensor not connected

private slots:
    void calculateProcess();
signals:
    void temperatureChanged();

    void sensorStatusChanged();

    void minutesRequiredChanged();

    void dbConnectedChanged();

    void addDataToDB(int place, bool occupied, const QString &name, float startTemperature, float weight);

    void weightCrateChanged();

    void weightCartChanged();

    void sensorCorrectionChanged();

private:
    QList<ProcessItem> m_processList;
    float m_temperature;
    int m_sensorStatus; // 0 - ok, 1 - module offline, 2 - sensor not connected
    QTimer *m_timerCalculateProcess;
    QSettings m_settings;

    int calculateRequiredMinutes(float startTemperature, float targetTemperature);
    float calculateExpextedTemperature(float startTemperature, int minutes);
    int m_minutesRequired;
    void readFromSettings();
    void writeToSettings();
    float m_weightCrate;
    float m_weightCart;
    float m_sensorCorrection;
};

#endif // PROCESSMODEL_H
