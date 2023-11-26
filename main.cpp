#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QList>
#include <QIcon>
#include "backend.h"
#include "usersettings.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    //设置软件图标
    app.setWindowIcon(QIcon(":/icon.png"));
    QQmlApplicationEngine engine;
    //配置对象
    UserSettings setting;

    //加这个 不让QSettings报警告，虽然没所谓就是了
    QCoreApplication::setOrganizationName("some organization");


    qmlRegisterType<Backend>("DmBackend",1,0,"Backend");



    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    //QML中的对象
    QList<QObject *> root = engine.rootObjects();
    Backend* backend = root.first()->findChild<Backend *>("qml_backend");
    QObject* dot_matrix_screen = root.first()->findChild<QObject *>("dot_matrix_screen");

    //首先读取default.ini中保存的最后打开的设置文件
    QVariant var_last_setting_path = setting.getConfig("last_setting_path");
    QString last_setting_path = var_last_setting_path.toString();
    if(!last_setting_path.isEmpty()){
        //如果有，则将setting路径设为最后打开的文件
        setting.setConfigPath(last_setting_path);
        //更改当前窗口标题
        root.first()->setProperty("title", "Dot-Matrix Tool - "+last_setting_path.split('/').last());
    }
    //根据目标ini恢复现场
    setting.recoveryValueToQml(&root);

    //生成代码
    QObject::connect(backend,&Backend::signalQmlScreenMatrixPoint ,[&]( QVariantList  points_list){
        auto qml_RowPoints = root.first()->findChild<QObject *>("Input_RowPoints")->property("dm_current_value").toInt();
        auto qml_ColPoints = root.first()->findChild<QObject *>("Input_ColPoints")->property("dm_current_value").toInt();
        auto qml_ReadMode = root.first()->findChild<QObject *>("Select_ReadMode")->property("dm_current_value").toInt();
        auto qml_ReadDirection = root.first()->findChild<QObject *>("Select_ReadDirection")->property("dm_current_value").toInt();
        auto qml_UnitWidth = root.first()->findChild<QObject *>("Select_UnitWidth")->property("dm_current_value").toInt();
        auto qml_DotLevel = root.first()->findChild<QObject *>("Select_DotLevel")->property("dm_current_value").toInt();
        auto qml_PerLineElements = root.first()->findChild<QObject *>("Input_PerLineElements")->property("dm_current_value").toInt();
        auto qml_code = root.first()->findChild<QObject *>("text_code_generator");

        int UnitWidth;
        if(qml_UnitWidth == Backend::UnitWidth_32Bits){
            UnitWidth = 32;
        }else if(qml_UnitWidth == Backend::UnitWidth_16Bits){
            UnitWidth = 16;
        }else{
            UnitWidth = 8;
        }
        int row_count=0;
        int col_count=0;
        if(qml_ReadMode == Backend::ReadMode_Row_By_Row || qml_ReadMode == Backend::ReadMode_Row_Col){
            //逐行式和行列式定义数组数量一样
            //每行数组长度
            int row_count = (qml_RowPoints + UnitWidth - 1) / UnitWidth;
            //列数一样
            int col_count = qml_ColPoints;
            QList<QList<uint32_t>> array;
            for(int col=0;col<col_count;col++){
                QList<uint32_t> temp_list;
                for(int row=0;row<row_count;row++){
                    temp_list.append(qml_DotLevel==Backend::DotLevel_HIGH?0:0xFFFFFFFF);
                }
                array.append(temp_list);
            }

            for(int index=0;index<points_list.size();index++){
                QPoint point = points_list.at(index).value<QPoint>();
                uint32_t mask = 1ULL<<(qml_ReadDirection==Backend::ReadDirection_Forward?(UnitWidth - (point.x() % UnitWidth) - 1):(point.x() % UnitWidth)) ;
                if(qml_DotLevel==Backend::DotLevel_HIGH){
                    array[point.y()][point.x() / UnitWidth] |= mask;
                }else{
                    array[point.y()][point.x() / UnitWidth] &= ~mask;
                }
            }
            QString output;
            auto count = 1;

            if(qml_ReadMode == Backend::ReadMode_Row_Col){
                //行列式代码
                for(int row=0;row<row_count;row++){
                    for(int col=0;col<col_count;col++){
                       output += QString("0x%1,").arg(array[col][row],UnitWidth/4,16,QChar('0'));
                       if(count++ == qml_PerLineElements){
                           count = 1;
                           output += "\r\n";
                       }
                    }

                }
            }else{
                //逐行式代码
                for(int row=0;row<row_count;row++){
                    for(int col=0;col<col_count;col++){
                       output += QString("0x%1,").arg(array[col/row_count][col%row_count],UnitWidth/4,16,QChar('0'));
                       if((count++) == qml_PerLineElements){
                           count = 1;
                           output += "\r\n";
                       }
                    }
                }
            }
            qml_code->setProperty("text", QVariant(output));


        }else if(qml_ReadMode == Backend::ReadMode_Col_By_Col || qml_ReadMode == Backend::ReadMode_Col_Row){
            //逐列式和列行式
            //每行数组长度
            row_count = qml_RowPoints;
            //列数一样
            col_count = (qml_ColPoints + UnitWidth - 1) / UnitWidth;

            QList<QList<uint32_t>> array;
            for(int col=0;col<col_count;col++){
                QList<uint32_t> temp_list;
                for(int row=0;row<row_count;row++){
                    temp_list.append(qml_DotLevel==Backend::DotLevel_HIGH?0:0xFFFFFFFF);
                }
                array.append(temp_list);
            }

            for(int index=0;index<points_list.size();index++){
                QPoint point = points_list.at(index).value<QPoint>();
                uint32_t mask = 1ULL<<(qml_ReadDirection==Backend::ReadDirection_Forward?(UnitWidth - (point.y() % UnitWidth) - 1):(point.y() % UnitWidth)) ;
                if(qml_DotLevel==Backend::DotLevel_HIGH){
                    array[point.y()/ UnitWidth][point.x() ] |= mask;
                }else{
                    array[point.y()/ UnitWidth][point.x() ] &= ~mask;
                }
            }
            QString output;

            auto count = 1;
            if(qml_ReadMode == Backend::ReadMode_Col_Row){
                //列行式代码
                for(int col=0;col<col_count;col++){
                    for(int row=0;row<row_count;row++){
                       output += QString("0x%1,").arg(array[row][col],UnitWidth/4,16,QChar('0'));

                        if(count++ == qml_PerLineElements){
                            count = 1;
                            output += "\r\n";
                        }

                    }
                }
                output +="};";
            }else{
                //逐列式代码
                for(int col=0;col<col_count;col++){
                    for(int row=0;row<row_count;row++){
                       output += QString("0x%1,").arg(array[col][row],UnitWidth/4,16,QChar('0'));

                        if(count++ == qml_PerLineElements){
                            count = 1;
                            output += "\r\n";
                        }
                    }
                }
            }
            qml_code->setProperty("text", QVariant(output));
        }
        //保存
        setting.setConfig("ScreenPoints",QVariant(points_list));
    });

    //保存参数于*.ini
    QObject::connect(backend,&Backend::signalQmlValueChange ,[&]( ){
        setting.saveValueFromQml(&root);
    });

    //创建新的setting配置
    QObject::connect(backend,&Backend::signalQmlCreateSetting ,[&]( QString  new_setting_name){
        //更改当前窗口标题
        root.first()->setProperty("title", "Dot-Matrix Tool - "+new_setting_name+".ini");
        //先把当前打开的配置路径写入默认配置中，以便下次打开软件时直接打开
        setting.setConfigPath(setting.getPathFromAppDir("default.ini"));
        setting.setConfig("last_setting_path", setting.getPathFromAppDir(new_setting_name+".ini"));
        //重新配置setting路径
        setting.setConfigPath(setting.getPathFromAppDir(new_setting_name+".ini"));
    });

    //打开setting配置
    QObject::connect(backend,&Backend::signalQmlOpenSetting ,[&]( QString  setting_path){
        setting_path = setting_path.split("///").last();
        QString setting_name = setting_path.split('/').last();
        //更改当前窗口标题
        root.first()->setProperty("title", "Dot-Matrix Tool - "+setting_name);
        //先把当前打开的配置路径写入默认配置中，以便下次打开软件时直接打开
        setting.setConfigPath(setting.getPathFromAppDir("default.ini"));
        setting.setConfig("last_setting_path", setting_path);
        //重新配置setting路径
        setting.setConfigPath(setting_path);
        //恢复现场
        setting.recoveryValueToQml(&root);
        //清空代码生成区
        root.first()->findChild<QObject *>("text_code_generator")->setProperty("text","");
    });

    return app.exec();
}
