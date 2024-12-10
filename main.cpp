#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QThread>
#include "readsensor.h"
#include "processmodel.h"
#include "productsmodel.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setOrganizationName("Kometa");
    QCoreApplication::setOrganizationDomain("kometa.hu");
    QCoreApplication::setApplicationName("Freezer");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ProcessModel *processModel = new ProcessModel(&app);
    qmlRegisterSingletonInstance("com.kometa.ProcessModel", 1, 1, "ProcessModel", processModel);

    ProductsModel *productsModel = new ProductsModel(&app);
    qmlRegisterSingletonInstance("com.kometa.ProductsModel", 1, 1, "ProductsModel", productsModel);

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
