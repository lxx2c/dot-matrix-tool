#include "usersettings.h"

UserSettings::UserSettings(QObject *parent) : QObject(parent)
{
    _settings =  new QSettings(_default_settings_path, QSettings::IniFormat);
}


QVariant UserSettings::getConfig(QString name){
    QVariant var = _settings->value(name);
    return var;
}


void UserSettings::setConfig(QString name, QVariant value){
    _settings->setValue(name,value);
}



QString UserSettings::getPathFromAppDir(QString file_Name){
    return _settings_dir.absoluteFilePath(file_Name);
}

void UserSettings::setConfigPath(QString full_path){
    _settings->~QSettings();
    _settings = new QSettings(full_path, QSettings::IniFormat);
}


void UserSettings::recoveryValueToQml(QList<QObject *> *obj){
    QObject * root = obj->first();
    //获取宽高和点
    QVariant width = getConfig(be.CustomValueTypeName[Backend::CustomValue_Window_Width]);
    QVariant height = getConfig(be.CustomValueTypeName[Backend::CustomValue_Window_Height]);


    if(!width.isNull()){
        root->setProperty("width", width);
    }
    if(!height.isNull()){
        root->setProperty("height", height);
    }

    for(auto i=0;i<Backend::CustomValue_Value_Type_Div;i++){
        QVariant value = getConfig(be.CustomValueTypeName[i]);
        if(!value.isNull()){
        //有数据则往QML中写入
            root->findChild<QObject *>(be.CustomValueTypeName[i])->setProperty("dm_input_value",value);
        }
    }
    //运行QML中resizeScreen函数重设屏幕
    QMetaObject::invokeMethod(root, "resizeScreen");

    QVariant points = getConfig(be.CustomValueTypeName[Backend::CustomValue_ScreenPoints]);
    if(!points.isNull()){
        //重绘屏幕点阵
        QObject * dot_matrix_screen = root->findChild<QObject *>("dot_matrix_screen");
        QMetaObject::invokeMethod(dot_matrix_screen, "clearScreen");
        QMetaObject::invokeMethod(dot_matrix_screen, "setScreenPoints",Q_ARG(QVariant,points) );
    }

}

void UserSettings::saveValueFromQml(QList<QObject *> *obj){
    QObject * root = obj->first();
    for(auto i=0;i<Backend::CustomValue_Value_Type_Div;i++){
        QObject* current_object = root->findChild<QObject *>(be.CustomValueTypeName[i]);
        auto value = current_object->property("dm_current_value");
        setConfig(be.CustomValueTypeName[i],value);
    }
    QVariant width = root->property("width");
    QVariant height = root->property("height");
    setConfig("width",width);
    setConfig("height",height);
}









