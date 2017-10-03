//+------------------------------------------------------------------+
//|                                            EagleFlyIndicator.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMTCommon.mqh>

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

    Comment("");
    ObjectsDeleteAll();
    ArrayResize(TempClose,KIJUN);
//--- indicator buffers mapping
    SetIndexBuffer(SB_CHIKOSPAN,SuperBolinger_ChikoSpan);
    SetIndexShift(SB_CHIKOSPAN,-KIJUN*SHIFT);
    SetIndexBuffer(SB_PLUS1SIGMA,SuperBolinger_Plus1Sigma);
    SetIndexBuffer(SB_MNUS1SIGMA,SuperBolinger_Mnus1Sigma);
    SetIndexBuffer(SB_SIMPLEMA,SuperBolinger_SimpleMA);
    SetIndexBuffer(SB_PLUS2SIGMA,SuperBolinger_Plus2Sigma);
    SetIndexBuffer(SB_MNUS2SIGMA,SuperBolinger_Mnus2Sigma);
    SetIndexBuffer(SB_PLUS3SIGMA,SuperBolinger_Plus3Sigma);
    SetIndexBuffer(SB_MNUS3SIGMA,SuperBolinger_Mnus3Sigma);

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
    
    //チャート作成    
    for(int i = rates_total - 12; i >= 1; i-- ){
        
        //時間を取得
        datetime Dtime = Time[i - 1];
        datetime ClcDtime = Time[i];

        double dTmpClose = close[i];
        datetime dTmpTime = time[i];
            
        if(TimeHour(Dtime) != TimeHour(ClcDtime)){
            dTmpClose = close[i];
            dTmpTime = time[i];       
        
            //1時間足の終値を取得
            for(int iCloseCount = 0; iCloseCount < KIJUN - 1; iCloseCount++){
                TempClose[iCloseCount] = TempClose[iCloseCount + 1];
            }
            TempClose[KIJUN - 1] = dTmpClose;

            if(TempClose[0] == NULL) continue;
        
            TempSimpleMA   = iBandMTF(TempClose,0);
            TempPlus1Sigma = iBandMTF(TempClose,1);
            TempMnus1Sigma = iBandMTF(TempClose,-1);
            TempPlus2Sigma = iBandMTF(TempClose,2);
            TempMnus2Sigma = iBandMTF(TempClose,-2);
            TempPlus3Sigma = iBandMTF(TempClose,3);
            TempMnus3Sigma = iBandMTF(TempClose,-3);
  
            //ローソク足を作成
            RosokuMTF(GetSMTID(i),time[i+11],open[i+11],time[i],close[i]);
           
        }
        
        //遅行スパン設定
        SuperBolinger_ChikoSpan[i]  = TempClose[KIJUN - 1];
        
        //単純移動平均線
        SuperBolinger_SimpleMA[i]   = TempSimpleMA;

        //プラス1シグマライン設定
        SuperBolinger_Plus1Sigma[i] = TempPlus1Sigma;
        
        //マイナス1シグマライン設定
        SuperBolinger_Mnus1Sigma[i] = TempMnus1Sigma;
        
        //プラス2シグマライン設定
        SuperBolinger_Plus2Sigma[i] = TempPlus2Sigma;
        
        //マイナス2シグマライン設定
        SuperBolinger_Mnus2Sigma[i] = TempMnus2Sigma;
        
        //プラス2シグマライン設定
        SuperBolinger_Plus3Sigma[i] = TempPlus3Sigma;
        
        //マイナス2シグマライン設定
        SuperBolinger_Mnus3Sigma[i] = TempMnus3Sigma;
        
    }        

    //--- return value of prev_calculated for next call
    return(rates_total);
  }
//+------------------------------------------------------------------+
//| スーパーボリンジャー作成                                             |
//+------------------------------------------------------------------+
double iBandMTF(double &iCloses[], int dDeviation){

    double dSigma = 0;
    double dSimpleMA = 0;
    double dCloseSum = 0;
    double dPoweredKCSum = 0;
    double dPoweredCloseSum = 0;
    double dTerm = 0;
    for(int i = 0; i < KIJUN; i++){

        //価格の合計
        dCloseSum = dCloseSum + iCloses[i];
        
        //価格の2乗の合計
        dPoweredKCSum = dPoweredKCSum + MathPow(iCloses[i],2);

    }
    
    //価格の合計の2乗
    dPoweredCloseSum = MathPow(dCloseSum,2);

    //期間*(期間-1)
    dTerm = KIJUN * (KIJUN - 1);
    
    //標準偏差
    dSigma = MathSqrt(((KIJUN * dPoweredKCSum) - dPoweredCloseSum) / dTerm);
    
    //単純移動平均線
    dSimpleMA = dCloseSum / KIJUN;

    return dSimpleMA + (dDeviation * dSigma);
    
}
//+------------------------------------------------------------------+
//| ローソク足作成                                                      |
//+------------------------------------------------------------------+
void RosokuMTF(string sObjID,
              datetime dStTime,
              double dStRate,
              datetime dEdTime,
              double dEdRate) {
   
    string sRosoku = "Rosoku_Body" + sObjID;

    //オブジェクト削除
    ObjectDelete(sRosoku);
    
    //ローソク足のボディを設定
    ObjectCreate(0,sRosoku,OBJ_RECTANGLE,0,dStTime,dStRate,dEdTime,dEdRate);
    
    //プロパティの設定
    ObjectSetInteger(0,sRosoku,OBJPROP_COLOR,clrBeige);
    ObjectSetInteger(0,sRosoku,OBJPROP_WIDTH,2);

    //背景の設定
    bool IsEnableBKColor = true;
    if(dStRate < dEdRate) IsEnableBKColor = false;
    ObjectSetInteger(0,sRosoku,OBJPROP_BACK,IsEnableBKColor);

}
//+------------------------------------------------------------------+