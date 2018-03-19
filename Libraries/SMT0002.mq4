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

//赤色スパン
   smr.dRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_REDSPAN,iBarNo-26);
   smr.dDelayedRedSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo);

//遅行スパン
   smr.dDelayedSpan=Close[iBarNo];

   return true;
  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパンチェック                                        |
//+------------------------------------------------------------------+
string CheckSMBlueSpan(double dBlueSpan,
                       double dRedSpan,
                       int iBarNo) export
  {

   string sRtnSignal=NOSIGNAL;

//買いシグナルの場合
   if(dRedSpan<dBlueSpan) sRtnSignal=SIGNALBUY;

//売りシグナルの場合
   else if(dRedSpan>dBlueSpan) sRtnSignal=SIGNALSELL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパンチェック                                           |
//+------------------------------------------------------------------+
string CheckSMDelayedSpan(double dSMDelayedSpan,
                          double dHighest,
                          double dLowest,
                          int iBarNo) export
  {
   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dSMDelayedSpan>dHighest) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(dSMDelayedSpan<dLowest) sRtnSignal=SIGNALSELL;

//上記以外
   else sRtnSignal=NOSIGNAL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スパンモデルシグマラインチェック                                           |
//+------------------------------------------------------------------+
string CheckSigmaLine(double dPlusSigma,
                      double dMnusSigma,
                      double dClose,
                      int iBarNo) export
  {
   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dClose>dPlusSigma) sRtnSignal=SIGNALBUY;

//売りシグナル点灯
   else if(dClose<dMnusSigma) sRtnSignal=SIGNALSELL;

//上記以外
   else sRtnSignal=NOSIGNAL;

   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| 青色スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMBlueSpan(string sSignal,
                                 double dBlueSpan,
                                 double dRedSpan,
                                 int iBarNo) export
  {

   bool bClosed=false;

//終値
   double dClose=Close[iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && dBlueSpan>=dClose)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALBUY && dBlueSpan<=dRedSpan)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dBlueSpan<=dClose)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dBlueSpan>=dRedSpan)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
//| 遅行スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMDelayedSpan(string sSignal,
                                    double dSMDelayedSpan,
                                    double dBlueSpan27,
                                    int iBarNo) export
  {

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dSMDelayedSpan<dBlueSpan27)
     {
      bClosed=true;
     }
   else if(sSignal==SIGNALSELL && dSMDelayedSpan>dBlueSpan27)
     {
      bClosed=true;
     }
   return bClosed;
  }
//+------------------------------------------------------------------+
