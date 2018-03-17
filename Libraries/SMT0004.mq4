//+------------------------------------------------------------------+
//|                                                      SMT0004.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//---- libraries
#include <SMT0000.mqh>

//+------------------------------------------------------------------+
//| 上位時間ローソク足情報取得                                         |
//+------------------------------------------------------------------+
bool GetUpperPeriodCandleInfo(Candle &cdl,int iBarNo) export
  {
   int i=iBarNo;
   
   //1時間足の変更時間検索
   while(i<iBarNo+Adjust_BarNo)
   {
    datetime dDateTime = Time[i];
    if(TimeHour(dDateTime) != TimeHour(Time[i+1]))
    {
     
     //1時間足の始値時間セット
     cdl.dOpenTime = dDateTime;

     //1時間足の終値時間セット
     int iCloseBarNo = i-Adjust_BarNo+1;
     if(iCloseBarNo < 0) return false;
     cdl.dCloseTime = iTime(NULL,PERIOD_M5,iCloseBarNo);
     break;
    }
    i++;
   }

   //1時間足の終値を返却
   int iShiftBarNo=iBarShift(NULL,PERIOD_H1,cdl.dOpenTime,false);
   cdl.dOpenRate  = iOpen(NULL,PERIOD_H1,iShiftBarNo);
   cdl.dCloseRate  = iClose(NULL,PERIOD_H1,iShiftBarNo);
   return true;
  }
//+------------------------------------------------------------------+
