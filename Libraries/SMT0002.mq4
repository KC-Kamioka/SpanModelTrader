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

SpanModelPrice smp;

//+------------------------------------------------------------------+
//| スパンモデルの値をセット                                                |
//+------------------------------------------------------------------+
SpanModelPrice SetNewSMPrice(int iBarNo) export
  {
   smp.dPreBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo+2-LOWERSENKOSEN);
   smp.dBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo+1-LOWERSENKOSEN);

//赤色スパン
   smp.dPreRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_REDSPAN,iBarNo+2-LOWERSENKOSEN);
   smp.dRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_REDSPAN,iBarNo+1-LOWERSENKOSEN);

//遅行スパン
   smp.dPreSMDelayedSpan=Close[iBarNo+2];
   smp.dSMDelayedSpan=Close[iBarNo+1];

//終値
   smp.dClose27=Close[LOWERSENKOSEN+iBarNo+1];

//高値
   smp.dHighest=High[iHighest(NULL,PERIOD_M5,MODE_HIGH,LOWERSENKOSEN+1,iBarNo+2)];

//安値
   smp.dLowest=Low[iLowest(NULL,PERIOD_M5,MODE_LOW,LOWERSENKOSEN+1,iBarNo+2)];

   return smp;
  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパンチェック                                        |
//+------------------------------------------------------------------+
string CheckSMBlueSpan(int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナルの場合
   if(smp.dRedSpan<smp.dBlueSpan) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(smp.dRedSpan>smp.dBlueSpan) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパンチェック                                           |
//+------------------------------------------------------------------+
string CheckSMDelayedSpan(int iBarNo) export
  {
   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(smp.dSMDelayedSpan>smp.dHighest) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(smp.dSMDelayedSpan<smp.dLowest) sRtnSignal=SIGNALSELL;
   
//上記以外
   else sRtnSignal=NOSIGNAL;
   
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMBlueSpan(string sSignal,int iBarNo) export
  {

   bool bClosed=false;

//終値
   double dClose=Close[iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && smp.dBlueSpan>=dClose)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALBUY && smp.dBlueSpan<=smp.dRedSpan)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && smp.dBlueSpan<=dClose)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && smp.dBlueSpan>=smp.dRedSpan)
     {
      bClosed=true;
     }
     return bClosed;
  }
//+------------------------------------------------------------------+
//| 遅行スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMDelayedSpan(string sSignal,int iBarNo) export
  {

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && smp.dSMDelayedSpan<=smp.dClose27)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && smp.dSMDelayedSpan>=smp.dClose27)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
