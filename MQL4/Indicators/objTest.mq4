//+------------------------------------------------------------------+
//|                                            EagleFlyIndicator.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//インジケータで使用するバッファの数を指定する。
#property indicator_buffers 8

//描画する線の情報を指定する。
//1.スーパーボリンジャー遅行スパン
#property indicator_label1 "SuperBolinger_ChikoSpan"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMagenta
#property indicator_style1  STYLE_SOLID
#property indicator_width1  4
//2.スーパーボリンジャープラス１シグマ
#property indicator_label2  "SuperBolinger_Plus1Sigma"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrOrange
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//3.スーパーボリンジャーマイナス１シグマ
#property indicator_label3  "SuperBolinger_Mnus1Sigma"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//2.単純移動平均線
#property indicator_label4  "SuperBolinger_SimpleMA"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrAquamarine
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//2.スーパーボリンジャープラス2シグマ
#property indicator_label5  "SuperBolinger_Plus2Sigma"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrBlueViolet
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//3.スーパーボリンジャーマイナス2シグマ
#property indicator_label6  "SuperBolinger_Mnus2Sigma"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrBlueViolet
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//2.スーパーボリンジャープラス3シグマ
#property indicator_label7  "SuperBolinger_Plus3Sigma"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrYellow
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1
//3.スーパーボリンジャーマイナス3シグマ
#property indicator_label8  "SuperBolinger_Mnus3Sigma"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrYellow
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1

//表示バッファ
double SuperBolinger_ChikoSpan[];
double SuperBolinger_Plus1Sigma[];
double SuperBolinger_Mnus1Sigma[];
double SuperBolinger_SimpleMA[];
double SuperBolinger_Plus2Sigma[];
double SuperBolinger_Mnus2Sigma[];
double SuperBolinger_Plus3Sigma[];
double SuperBolinger_Mnus3Sigma[];

//変数
int ExtPeriod = PERIOD_M5;
int KIJUN = 21;
int SHIFT = 12;
double TempClose[];
double TempPlus1Sigma;
double TempMnus1Sigma;
double TempSimpleMA;
double TempPlus2Sigma;
double TempMnus2Sigma;
double TempPlus3Sigma;
double TempMnus3Sigma;
string OutCom = NULL;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){

    ObjectsDeleteAll();
    
//---
    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,          //各レート要素数
                const int prev_calculated,      //計算済み要素数
                const datetime &time[],         //要素ごとの時間配列
                const double &open[],           //オープン価格配列
                const double &high[],           //高値配列
                const double &low[],            //安値配列
                const double &close[],          //クローズ価格配列
                const long &tick_volume[],      //ティック数（要素の更新回数）
                const long &volume[],           //実ボリューム
                const int &spread[])            //スプレット
  {
    
    int testcount = rates_total-11;
    double dTmpClose = close[testcount];
    datetime dTmpTime = time[testcount];

    //チャート作成
    for(int i = testcount; i >= 1; i-- ){
        
        //時間を取得
        datetime Dtime = Time[i - 1];
        datetime ClcDtime = Time[i];

        if(TimeHour(Dtime) != TimeHour(ClcDtime)){
                   
            //ローソク足を作成
            RosokuMTF(IntegerToString(i),time[i+11],open[i+11],time[i],close[i]);
        
        }
    }        

    //--- return value of prev_calculated for next call
    return(rates_total);
  }
//+------------------------------------------------------------------+
//| ローソク足作成                                                      |
//+------------------------------------------------------------------+
void RosokuMTF(string sID,
              datetime dStTime,
              double dStRate,
              datetime dEdTime,
              double dEdRate) {
   
    string obj_name1 = "Rosoku_Body" + sID;

    //ローソク足のボディを設定
    ObjectCreate(0,obj_name1,          // オブジェクト作成
                 OBJ_RECTANGLE,              // オブジェクトタイプ
                 0,                          // サブウインドウ番号
                 dStTime,                   // 1番目の時間のアンカーポイント
                 dStRate,                  // 1番目の価格のアンカーポイント
                 dEdTime,                   // 2番目の時間のアンカーポイント
                 dEdRate                   // 2番目の価格のアンカーポイント
                 );
    
    //背景の設定
    bool IsEnableBKColor = true;
    if(dStRate < dEdRate) IsEnableBKColor = false;
    ObjectSetInteger(0,obj_name1,OBJPROP_BACK,IsEnableBKColor);

}
//+------------------------------------------------------------------+