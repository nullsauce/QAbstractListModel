#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "QVariantListModel.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QVariantListModel model;
    engine.rootContext()->setContextProperty("testModel", &model);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
