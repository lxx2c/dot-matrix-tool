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

    QList<QString> CustomValueTypeName = {
         "Input_RowPoints",
         "Input_ColPoints",
         "Input_Spacing",
         "Input_Size",
         "Input_Color",
         "Input_PerLineElements",
         "Select_ReadMode",
         "Select_ReadDirection",
         "Select_UnitWidth",
         "Select_DotLevel",
         "Value_Type_Div",
         "ScreenPoints",
         "Width",
         "Height"
     };

    enum CustomValueType {
        CustomValue_Input_RowPoints=0,  //行点数
        CustomValue_Input_ColPoints,    //列点数
        CustomValue_Input_Spacing,      //点间距
        CustomValue_Input_Size,         //点大小
        CustomValue_Input_Color,        //点颜色
        CustomValue_Input_PerLineElements,  //生成代码的每行数量
        CustomValue_Select_ReadMode,    //取模方式
        CustomValue_Select_ReadDirection,   //取模方向
        CustomValue_Select_UnitWidth,   //字节宽度
        CustomValue_Select_DotLevel,    //触发电平
        CustomValue_Value_Type_Div,//分割，在上面的为用户输入参数，在qml中使用dm_value来存储值
        CustomValue_ScreenPoints,
        CustomValue_Window_Width,
        CustomValue_Window_Height,
        CustomValueCount
    };

    //取模方式
    enum ReadModeType {
        ReadMode_Row_By_Row, //逐行
        ReadMode_Col_By_Col, //逐列
        ReadMode_Row_Col,    //行列式
        ReadMode_Col_Row     //列行式
    };

    //取模方向
    enum ReadDirectionType {
        ReadDirection_Forward,
        ReadDirection_Backward,
    };

    //触点电平
    enum DotLevelType {
        DotLevel_HIGH,
        DotLevel_LOW
    };

    //单位宽度
    enum UnitWidthType {
        UnitWidth_8Bits,
        UnitWidth_16Bits,
        UnitWidth_32Bits,
    };


private:
    QVariantList m_screen_matrix_point;

signals:

    //生成代码信号
    void signalQmlScreenMatrixPoint(QVariantList point_list);
    //参数改变信号
    void signalQmlValueChange();
    //创建ini信号
    void signalQmlCreateSetting(QString file_name);
    //打开ini信号
    void signalQmlOpenSetting(QString path);
};

#endif // BACKEND_H
