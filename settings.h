#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QDir>
#include <QCoreApplication>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = nullptr);
//    QSettings settings("da.ini", QSettings::IniFormat,nullptr);

private:
    //创建dir对象
    QDir _sqlite_dir = QDir(QCoreApplication::applicationDirPath());
    QString _sqlite_path = _sqlite_dir.absoluteFilePath("dmtData.ini");

signals:

};

#endif // SETTINGS_H
