#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include <QObject>
#include <QSettings>
#include <QDir>
#include <QCoreApplication>
#include <QtCore>
#include <QDebug>
#include <QString>
#include <QMetaObject>

#include <QList>

#include "backend.h"

class UserSettings : public QObject
{
    Q_OBJECT

private:
    //创建dir对象
    QDir _settings_dir = QDir(QCoreApplication::applicationDirPath());
    QString _default_file_name = "default.ini";
    QString _default_settings_path = _settings_dir.absoluteFilePath(_default_file_name);
    QSettings *_settings;
    Backend be;


public:
    explicit UserSettings(QObject *parent = nullptr);

    QVariant getConfig(QString name);
    void setConfig(QString name, QVariant value);
    QString getPathFromAppDir(QString file_Name);
    void setConfigPath(QString full_path);

    //从setting中恢复数据至QML
    void recoveryValueToQml(QList<QObject *> *obj);
    void saveValueFromQml(QList<QObject *> *obj);
signals:

};

#endif // USERSETTINGS_H
