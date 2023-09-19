#include "sqlitedb.h"

SqliteDB::SqliteDB()
{
    _db = QSqlDatabase::addDatabase("QSQLITE");
    _db.setDatabaseName(_sqlite_path);
    if(!_db.isOpen()){
        if(_db.open()){
            qDebug()<<"open sqlite success";
        }else{
            qDebug()<<"open sqlite failed";
        }
    }
}


QString SqliteDB::getValueByName(QString name){
    return "";
}

bool SqliteDB::setValueByName(QString name, QString value){
    return 0;
}
