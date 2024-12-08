#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QThread>
#include "readsensor.h"
#include "processmodel.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ProcessModel *processModel = new ProcessModel(&app);
    qmlRegisterSingletonInstance("com.kometa.ProcessModel", 1, 1, "ProcessModel", processModel);

    ReadSensor *readSensor = new ReadSensor();
    QThread *threadReadSensor = new QThread();
    QObject::connect(threadReadSensor, &QThread::started, readSensor, &ReadSensor::run);

    readSensor->moveToThread(threadReadSensor);
    // threadReadSensor->start();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("freezer", "Main");

    return app.exec();
}
