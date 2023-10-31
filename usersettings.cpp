#include "usersettings.h"

UserSettings::UserSettings(QObject *parent) : QObject(parent)
{
//    settings = QSettings(_settings_path, QSettings::IniFormat);
//   qDebug()<<_sqlite_path;
//    _settings =  new QSettings(QSettings::IniFormat, QSettings::UserScope,"waynework","dm-tool");
    _settings =  new QSettings(_settings_path, QSettings::IniFormat);
    qDebug()<<_settings_path;
    qDebug()<<_settings->fileName();
}


QVariant UserSettings::getConfig(QString name){
    QVariant var = _settings->value(name);
    return var;
}


void UserSettings::setConfig(QString name, QVariant value){
    _settings->setValue(name,value);
}




