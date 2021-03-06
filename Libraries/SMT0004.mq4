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
      datetime dDateTime=Time[i];
      if(TimeHour(dDateTime)!=TimeHour(Time[i+1]))
        {

         //1時間足の始値時間セット
         cdl.dOpenTime=dDateTime;

         //1時間足の終値時間セット
         int iCloseBarNo=i-Adjust_BarNo+1;
         if(iCloseBarNo < 0) return false;
         cdl.dCloseTime=iTime(NULL,PERIOD_M5,iCloseBarNo);
         break;
        }
      i++;
     }

   int iShiftBarNo=iBarShift(NULL,PERIOD_H1,cdl.dOpenTime,false);

//1時間足の始値をセット
   cdl.dOpenRate=iOpen(NULL,PERIOD_H1,iShiftBarNo);

//1時間足の終値をセット
   cdl.dCloseRate=iClose(NULL,PERIOD_H1,iShiftBarNo);

//1時間足の最高値をセット
   int iHighestBarNo=iHighest(NULL,PERIOD_H1,MODE_CLOSE,iBarNo+22,iBarNo+2);
   cdl.dHighRate=iHigh(NULL,PERIOD_H1,iHighestBarNo);

//1時間足の最安値をセット
   int iLowestBarNo=iLowest(NULL,PERIOD_H1,MODE_CLOSE,iBarNo+22,iBarNo+2);
   cdl.dLowRate=iLow(NULL,PERIOD_H1,iLowestBarNo);

   return true;
  }
//+------------------------------------------------------------------+
