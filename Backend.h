#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QPoint>
#include <QVector>
#include <QVariant>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);
    Q_INVOKABLE QVariantList getScreenMatrixPoint(){return m_screen_matrix_point;};

    enum ValueType {
            Input_Row_Point=0, Input_Col_Point, Input_Spacing, Input_Size,  Select_Read, Select_Storage, Select_Unit, Select_Level, Value_Type_Max,//分割
            Scrren_Points, Window_Width, Window_Height, Component_Completed };
QList<QString> ObjectName = {
           "Input_Row_Point","Input_Col_Point","Input_Spacing","Input_Size","Select_Read","Select_Storage","Select_Unit","Select_Level","Value_Type_Max",
            "Scrren_Points","Window_Width","Window_Height","Component_Completed"};
Q_ENUM(ValueType)
private:
    QVariantList m_screen_matrix_point;

signals:

    void signalQmlBuildButtonClicked();

    void signalQmlScreenMatrixPoint(QVariantList point_list);

    void signalQmlValueChange(int index);
};

#endif // BACKEND_H
