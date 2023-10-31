#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include <QObject>
#include <QSettings>
#include <QDir>
#include <QCoreApplication>
#include <QtCore>
#include <QDebug>
#include <QString>

class UserSettings : public QObject
{
    Q_OBJECT

private:
    //创建dir对象
    QDir _settings_dir = QDir(QCoreApplication::applicationDirPath());
    QString _settings_path = _settings_dir.absoluteFilePath("config.ini");
    QSettings *_settings;
public:
    explicit UserSettings(QObject *parent = nullptr);

    QVariant getConfig(QString name);
    void setConfig(QString name, QVariant value);


signals:

};

#endif // USERSETTINGS_H
