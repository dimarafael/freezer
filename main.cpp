#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QThread>
#include "readsensor.h"
#include "processmodel.h"
#include "productsmodel.h"
#include "dbmanager.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setOrganizationName("Kometa");
    QCoreApplication::setOrganizationDomain("kometa.hu");
    QCoreApplication::setApplicationName("Freezer");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath());

    ProcessModel *processModel = new ProcessModel(&app);
    qmlRegisterSingletonInstance("com.kometa.ProcessModel", 1, 1, "ProcessModel", processModel);

    ProductsModel *productsModel = new ProductsModel(&app);
    qmlRegisterSingletonInstance("com.kometa.ProductsModel", 1, 1, "ProductsModel", productsModel);

    ReadSensor *readSensor = new ReadSensor();
    QThread *threadReadSensor = new QThread();
    QObject::connect(threadReadSensor, &QThread::started, readSensor, &ReadSensor::run);

    readSensor->moveToThread(threadReadSensor);
    threadReadSensor->start();

    QObject::connect(readSensor, &ReadSensor::dataReady, processModel, &ProcessModel::dataReady);

    DBManager *dbManager = new DBManager();
    QThread *threadDBManager = new QThread();
    QObject::connect(threadDBManager, &QThread::started, dbManager, &DBManager::run);
    QObject::connect(processModel, &ProcessModel::addDataToDB, dbManager, &DBManager::addData);
    QObject::connect(dbManager, &DBManager::dbConnected, processModel, &ProcessModel::setDbConnected);
    dbManager->moveToThread(threadDBManager);
    threadDBManager->start();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("freezer", "Main");

    return app.exec();
}
