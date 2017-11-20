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

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <SMT0003.mqh>
#include <SMT0006.mqh>

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
int ExtPeriod=PERIOD_M5;
double TempClose[];
double TempPlus1Sigma;
double TempMnus1Sigma;
double TempSimpleMA;
double TempPlus2Sigma;
double TempMnus2Sigma;
double TempPlus3Sigma;
double TempMnus3Sigma;
string OutCom=NULL;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   Comment("");
   ObjectsDeleteAll();
   ArrayResize(TempClose,UPPERSENKOSEN);
//--- indicator buffers mapping
   SetIndexBuffer(SB_DELAYEDSPAN,SuperBolinger_ChikoSpan);
   SetIndexShift(SB_DELAYEDSPAN,-UPPERDELAYEDSPANBARNO);
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
   for(int i=rates_total-Adjust_BarNo; i>0; i--)
     {

      //一時間足のバーの位置
      int iBarPlace=iBarShift(NULL,PERIOD_H1,Time[i]);

      //始値の時間
      datetime dtOpenTime=iTime(NULL,PERIOD_H1,iBarPlace);

      //始値
      double dOpen=iOpen(NULL,PERIOD_H1,iBarPlace);

      //終値
      double dClose=iClose(NULL,PERIOD_H1,iBarPlace);

      //遅行スパン設定
      SuperBolinger_ChikoSpan[i]=dClose;

      //単純移動平均線
      SuperBolinger_SimpleMA[i]=iBands(NULL,PERIOD_H1,21,0,0,PRICE_CLOSE,0,iBarPlace);

      //プラス1シグマライン設定
      SuperBolinger_Plus1Sigma[i]=iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,1,iBarPlace);

      //マイナス1シグマライン設定
      SuperBolinger_Mnus1Sigma[i]=iBands(NULL,PERIOD_H1,21,1,0,PRICE_CLOSE,2,iBarPlace);

      //プラス2シグマライン設定
      SuperBolinger_Plus2Sigma[i]=iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,1,iBarPlace);

      //マイナス2シグマライン設定
      SuperBolinger_Mnus2Sigma[i]=iBands(NULL,PERIOD_H1,21,2,0,PRICE_CLOSE,2,iBarPlace);

      //プラス3シグマライン設定
      SuperBolinger_Plus3Sigma[i]=iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,1,iBarPlace);

      //マイナス3シグマライン設定
      SuperBolinger_Mnus3Sigma[i]=iBands(NULL,PERIOD_H1,21,3,0,PRICE_CLOSE,2,iBarPlace);

      //ローソク足を作成
      if(TimeHour(Time[i])!=TimeHour(Time[i+1]))
        {
         RosokuMTF(GetSMTID(i),Time[i+11],Open[i+11],Time[i],Close[i]);
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
