#ifndef SQLITEDB_H
#define SQLITEDB_H

#include <QObject>
#include <QCoreApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QDebug>
#include <QSettings>

class SqliteDB
{
public:
    SqliteDB();

    QString getValueByName(QString name);
    bool setValueByName(QString name, QString value);

private:
    //创建dir对象
    QDir _sqlite_dir = QDir(QCoreApplication::applicationDirPath());
    QString _sqlite_path = _sqlite_dir.absoluteFilePath("dmtData.db");
    //数据库对象
    QSqlDatabase _db;
};

#endif // SQLITEDB_H
