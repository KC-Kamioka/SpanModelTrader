//+------------------------------------------------------------------+
//|                                          SMTSignalVisualizer.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 260

#include <SMT0000.mqh>
#include <SMT0003.mqh>

#define KEY_LEFT 37
#define KEY_UP 38
#define KEY_RIGHT 39
#define KEY_DOWN 40
int iSymbolNo=0;
int iSMTOBarNo=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){

//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
//---
 
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//キーが押下された場合
   if(id!=CHARTEVENT_KEYDOWN) return;

//下キーが押下されたとき
   if(int(lparam)==KEY_LEFT)
     {
      //前の時間をセット
      iSMTOBarNo=iSMTOBarNo+Adjust_BarNo;
     }

//下キーが押下されたとき
   else if(int(lparam)==KEY_RIGHT)
     {
      //次の時間をセット
      iSMTOBarNo=iSMTOBarNo-Adjust_BarNo;
      if(iSMTOBarNo<0) iSMTOBarNo=0;
     }

//通貨ペア
   string sSymbol=Symbol();

//時間
   datetime dtTimeClose=iTimeMTF(sSymbol,iSMTOBarNo);

//高値のバーの位置
int iHighestBarNo=iHighestMTF(sSymbol,iSMTOBarNo);

//安値のバーの位置
int iLowestBarNo=iLowestMTF(sSymbol,iSMTOBarNo);

//オブジェクト作成
   string sObjName="SMTComments";
   ObjectDelete(sObjName);
   ObjectCreate(sObjName,OBJ_VLINE,0,dtTimeClose,0);
   ObjectSet(sObjName,OBJPROP_COLOR,LightBlue);
   
//コメント表示
   string sContents="通貨ペア:"+sSymbol+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"始値:"+DoubleToString(iOpenMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"終値:"+DoubleToString(iCloseMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(iTime(NULL,PERIOD_H1,iHighestBarNo))+" "+"高値:"+DoubleToString(iClose(NULL,PERIOD_H1,iHighestBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(iTime(NULL,PERIOD_H1,iLowestBarNo))+" "+"安値:"+DoubleToString(iClose(NULL,PERIOD_H1,iLowestBarNo))+SMTRTNCODE;
   Comment(sContents);
  }
//+------------------------------------------------------------------+
