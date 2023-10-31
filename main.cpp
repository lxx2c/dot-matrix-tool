#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QList>

#include "sqlitedb.h"
#include "backend.h"
#include "usersettings.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    SqliteDB db;
    UserSettings setting;
    QVariant value(1);

    setting.setConfig("name",value);



    qmlRegisterType<Backend>("DmBackend",1,0,"Backend");



    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QList<QObject *> root = engine.rootObjects();
    Backend* backend = root.first()->findChild<Backend *>("qml_backend");
    QObject* dot_matrix_screen = root.first()->findChild<QObject *>("dot_matrix_screen");



    //读取设置并恢复
    for(int i =0;i<Backend::Value_Type_Max;i++){
        QString objectName = backend->ObjectName.at(i);
        QObject* qml_object = root.first()->findChild<QObject *>(objectName);
        auto value = setting.getConfig(objectName);
        qml_object->setProperty("dm_value",value);
    }
    //重设窗口长宽
    root.first()->setProperty("width",setting.getConfig("width"));
    root.first()->setProperty("height",setting.getConfig("height"));

    //重设点阵屏大小
    dot_matrix_screen->setProperty("dm_dot_row_point"   ,setting.getConfig("Input_Row_Point"));
    dot_matrix_screen->setProperty("dm_dot_col_point"   ,setting.getConfig("Input_Col_Point"));
    dot_matrix_screen->setProperty("dm_dot_spacing"     ,setting.getConfig("Input_Spacing"));
    dot_matrix_screen->setProperty("dm_dot_size"        ,setting.getConfig("Input_Size"));

    //恢复点阵屏
    QVariant points = setting.getConfig("Scrren_Points");
    QMetaObject::invokeMethod(dot_matrix_screen, "setScreenPoints",Q_ARG(QVariant,points) );

    qDebug()<<"points"<<points;

    QObject::connect(backend,&Backend::signalQmlBuildButtonClicked ,[=](){
        //QML中点击生成代码
        //获取qml中的屏幕矩阵变量
//        QList<QVariant> qml_screen_dot_matrix = dot_matrix_screen->property("dm_screen_dot_matrix").toList();
//        auto qml_screen_dot_matrix = dot_matrix_screen->property("dm_screen_dot_matrix");
//        qDebug()<<"canConvert(QVariant::List)"<<qml_screen_dot_matrix.canConvert(QVariant::List);
//        QList<QVariant> qml_screen_dot_matrix_list;

//        if(qml_screen_dot_matrix.canConvert(QVariant::List)){
//            try {
//                qml_screen_dot_matrix_list = qml_screen_dot_matrix.toList();
//                for(int i=0;i<qml_screen_dot_matrix_list.size();i++){

//                    QList<QVariant> qml_screen_dot_row_list ;
//                    qml_screen_dot_row_list = qml_screen_dot_matrix_list.at(i).toList();
//                    QList<int> row;
////                    qDebug()<<i<<"qml_screen_dot_row_list.size()"<<qml_screen_dot_row_list.size()<<qml_screen_dot_row_list;
//                    for(int j=0;j<qml_screen_dot_row_list.size();j++){
//                        row.append(qml_screen_dot_row_list.at(j).toInt());
//                    }
//                    qDebug()<<i<<row;
//                }
//            }  catch (QString e) {
//                qDebug()<<"e"<<e;
//            }catch(...){
//                qDebug()<<"elese";
//                QList<QList<bool>> a;
//            }

//        }
//        auto qml_screen_dot_matrix = qml_screen_dot_matrix1.toList();
//        qDebug()<<"qml_screen_dot_matrix.size()"<<qml_screen_dot_matrix.size();


//        qDebug()<<"len";
//        qDebug()<<"len";

    });

    QObject::connect(backend,&Backend::signalQmlScreenMatrixPoint ,[&]( QVariantList  a){
        qDebug()<<"a:"<<a.size();
        QList<QVariant> list;
        for(int i=0;i<a.size();i++){

            QVariant point = a.at(i);
            list.append(point);
            QPointF mpoint = point.value<QPointF>();
            qDebug()<<i<<mpoint;
        }
        QVariantList aa;
        setting.setConfig("Scrren_Points",QVariant(list));
    });

    //各种参数被修改
    QObject::connect(backend,&Backend::signalQmlValueChange ,[&]( int  type_index){
        if(type_index >= backend->ObjectName.size()){
            qDebug()<<"error"<<type_index;
            return ;
        }
        QString current_object_name = backend->ObjectName.at(type_index);
        QObject* current_object = root.first()->findChild<QObject *>(current_object_name);
         qDebug()<<type_index<<current_object_name;
        if(type_index < Backend::Value_Type_Max){
            auto value = current_object->property("dm_value");
            setting.setConfig(current_object_name,value);
        }else if(type_index == Backend::Window_Width){
            qDebug()<<"width"<<root.first()->property("width");
            setting.setConfig("width",root.first()->property("width"));
        }else if(type_index == Backend::Window_Height){
            qDebug()<<"height"<<root.first()->property("height");
            setting.setConfig("height",root.first()->property("height"));
        }

    });


    return app.exec();
}
