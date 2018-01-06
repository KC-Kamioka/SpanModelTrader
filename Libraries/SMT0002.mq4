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
//| スパンモデルの値をセット                                                |
//+------------------------------------------------------------------+
SpanModelPrice SetNewSMPrice(int iBarNo) export
  {

   SpanModelPrice smp;

//青色スパン
   smp.dPreBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo+2-LOWERSENKOSEN);
   smp.dBlueSpan=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo+1-LOWERSENKOSEN);
   smp.dBlueSpan27=iIchimoku(NULL,PERIOD_M5,9,26,52,SM_BLUESPAN,iBarNo+1);

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

//プラス２シグマライン
   smp.dPlusSigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,iBarNo+1);

//マイナス２シグマライン
   smp.dMnusSigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,iBarNo+1);

   return smp;
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
