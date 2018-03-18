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
#include <SMT0004.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

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
                const int &spread[])
  {
//---
   Candle cdl;
   //for(int i=0; i<rates_total-UPPERDELAYEDSPANBARNO-1; i++)
   for(int i=0; i<100; i++)
     {
      if(GetUpperPeriodCandleInfo(cdl,i))
        {
         string sObjName="Range_"+TimeToString(Time[i]);

         //既存のオブジェクトを削除
         if(ObjectFind(sObjName)<0) ObjectDelete(sObjName);

         //オブジェクト作成
         ObjectCreate(0,sObjName,OBJ_RECTANGLE,1,Time[i],100,Time[i+3],200);
         
         //プロパティの設定
         ObjectSetInteger(0,sObjName,OBJPROP_COLOR,clrBlue);
         ObjectSetInteger(0,sObjName,OBJPROP_WIDTH,10);

         //背景の設定
         bool IsEnableBKColor=true;
         if(cdl.dOpenRate<=cdl.dCloseRate) IsEnableBKColor=false;
         ObjectSetInteger(0,sObjName,OBJPROP_BACK,IsEnableBKColor);
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
