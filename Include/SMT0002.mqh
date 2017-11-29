//+------------------------------------------------------------------+
//|                                                      SMT0002.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>

//+------------------------------------------------------------------+
//| 定数                                                             |
//+------------------------------------------------------------------+
#define SM_INDICATORNAME  "SpanModel"
#define SM_BLUESPAN 5
#define SM_REDSPAN  6

//+------------------------------------------------------------------+
//| 変数                                                             |
//+------------------------------------------------------------------+
//青色スパン
double dPreBlueSpan=0;
double dBlueSpan=0;

//赤色スパン
double dPreRedSpan=0;
double dRedSpan=0;

//遅行スパン
double dSMDelayedSpan=0;

//終値
double dClose27=0;

//高値
double dHighest=0;

//安値
double dLowest=0;

//スパンモデル遅行スパン時のスーパーボリンジャーの値
double dSMPlusSigma27=0;
double dSMMnusSigma27=0;
//+------------------------------------------------------------------+
//| スパンモデルの値をセット                                                |
//+------------------------------------------------------------------+
void SetNewSMPrice(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="SetNewSMPrice";
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0033",iBarNo);
   string sRtnSignal=NOSIGNAL;

//青色スパン
   dPreBlueSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_BLUESPAN,iBarNo+2);
   dBlueSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_BLUESPAN,iBarNo+1);

//赤色スパン
   dPreRedSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_REDSPAN,iBarNo+2);
   dRedSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_REDSPAN,iBarNo+1);

//遅行スパン
   dSMDelayedSpan=Close[iBarNo+1];

//終値
   dClose27=Close[LOWERSENKOSEN+iBarNo+1];

//高値
   dHighest=High[iHighest(NULL,PERIOD_M5,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+2)];

//安値
   dLowest=Low[iLowest(NULL,PERIOD_M5,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+2)];

//22本前のシグマラインの値
   dSMPlusSigma27=iBandsMTF(Symbol(),SB_PLUS3SIGMA,LOWERSENKOSEN+iBarNo+1);

//22本前のシグマラインの値
   dSMMnusSigma27=iBandsMTF(Symbol(),SB_MNUS3SIGMA,LOWERSENKOSEN+iBarNo+1);

   TrailLog("INFO",CLASSNAME2,sProcessName,"１つ前の青色スパン："+DoubleToString(dBlueSpan),iBarNo);
   TrailLog("INFO",CLASSNAME2,sProcessName,"１つ前の赤色スパン："+DoubleToString(dPreRedSpan),iBarNo);
   TrailLog("INFO",CLASSNAME2,sProcessName,"青色スパン："+DoubleToString(dBlueSpan),iBarNo);
   TrailLog("INFO",CLASSNAME2,sProcessName,"赤色スパン："+DoubleToString(dRedSpan),iBarNo);
   TrailLog("INFO",CLASSNAME2,sProcessName,"遅行スパン："+DoubleToString(dSMDelayedSpan),iBarNo);
   TrailLog("INFO",CLASSNAME2,sProcessName,"27本前の終値："+DoubleToString(dClose27),iBarNo);

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0034",iBarNo);
   return;
  }
//+------------------------------------------------------------------+
//| スパンモデル青色スパンチェック                                        |
//+------------------------------------------------------------------+
string CheckSMBlueSpan(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckSMBlueSpan";
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//買いシグナルの場合
   if(dPreRedSpan>=dPreBlueSpan && dRedSpan<dBlueSpan)
     {
      sRtnSignal=SIGNALBUY;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0046",iBarNo);
     }

//売りシグナルの場合
   else if(dPreRedSpan<=dPreBlueSpan && dRedSpan>dBlueSpan)
     {
      sRtnSignal=SIGNALSELL;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0047",iBarNo);
     }

//上記以外
   else
     {
      sRtnSignal=NOSIGNAL;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0045",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0034",iBarNo);
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパンチェック                                           |
//+------------------------------------------------------------------+
string CheckSMDelayedSpan(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckSMDelayedSpan";
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0033",iBarNo);

   string sRtnSignal=NOSIGNAL;

//買いシグナル点灯
   if(dSMDelayedSpan>dHighest)
     {
      sRtnSignal=SIGNALBUY;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0046",iBarNo);
     }

//売りシグナル点灯
   else if(dSMDelayedSpan<dLowest)
     {
      sRtnSignal=SIGNALSELL;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0047",iBarNo);
     }

//上記以外
   else
     {
      sRtnSignal=NOSIGNAL;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0045",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0034",iBarNo);
   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| 青色スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMBlueSpan(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SMBlueSpan";
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//終値
   double dClose=Close[iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && dBlueSpan>=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0109",iBarNo);
     }
   else if(sSignal==SIGNALBUY && dBlueSpan<=dRedSpan)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0109",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dBlueSpan<=dClose)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0110",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dBlueSpan>=dRedSpan)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0110",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0034",iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| 遅行スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMDelayedSpan(string sSignal,int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SMDelayedSpan";
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0033",iBarNo);

   bool bClosed=false;

//決済シグナル確認
   if(sSignal==SIGNALBUY && dSMDelayedSpan<=dClose27)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0009",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dSMDelayedSpan>=dClose27)
     {
      bClosed=true;
      TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0010",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",CLASSNAME2,sProcessName,"MSG0034",iBarNo);
   return bClosed;
  }
//+------------------------------------------------------------------+
