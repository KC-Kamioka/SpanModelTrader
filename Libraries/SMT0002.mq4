//+------------------------------------------------------------------+
//|                                                      SMT0002.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define SM_INDICATORNAME  "SpanModel"
#define SM_BLUESPAN 3
#define SM_REDSPAN  4
//+------------------------------------------------------------------+
//| スパンモデルの値を取得                                                |
//+------------------------------------------------------------------+
bool GetSpanModelRate(SpanModelRate &smr,int iBarNo) export
  {

//青色スパン
   smr.dBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo-26);
   smr.dDelayedBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo);

//高値
   smr.dHighest=High[iHighest(NULL,PERIOD_M5,MODE_CLOSE,27,iBarNo+1)];

//赤色スパン
   smr.dRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_REDSPAN,iBarNo-26);
   smr.dDelayedRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_REDSPAN,iBarNo);

//安値
   smr.dLowest=Low[iLowest(NULL,PERIOD_M5,MODE_CLOSE,27,iBarNo+1)];

//遅行スパン
   smr.dDelayedSpan=Close[iBarNo];

//プラス１シグマライン
   smr.dPlus1Sgma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,iBarNo);

//マイナス１シグマライン
   smr.dMnus1Sgma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,iBarNo);

//プラス２シグマライン
   smr.dPlus2Sgma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo);

//マイナス２シグマライン
   smr.dMnus2Sgma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo);

//プラス３シグマライン
   smr.dPlus3Sgma=iBands(NULL,PERIOD_M5,21,3,0,PRICE_CLOSE,1,iBarNo);

//マイナス３シグマライン
   smr.dMnus3Sgma=iBands(NULL,PERIOD_M5,21,3,0,PRICE_CLOSE,2,iBarNo);

   return true;
  }
//+------------------------------------------------------------------+
