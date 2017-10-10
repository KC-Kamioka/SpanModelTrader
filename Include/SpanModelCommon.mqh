//+------------------------------------------------------------------+
//|                                              SpanModelCommon.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMTCommon.mqh>
//+------------------------------------------------------------------+
//| スパンモデル青色スパンチェック                                           |
//+------------------------------------------------------------------+
void CheckSMBlueSpan(int iBarNo=0)
  {

/*
    //シグナル消灯
    if(SessionSMBSpanSigCnt >= LOWERSIGNALLM){
        SetSessionSMBSSignal(NOSIGNAL,iBarNo);
        return;
    }
*/
//青色スパン
   double dBlueSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",5,iBarNo+1);
   double dPreBlueSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",5,iBarNo+2);

//赤色スパン
   double dRedSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",6,iBarNo+1);
   double dPreRedSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",6,iBarNo+2);

//シグナル点灯中の場合
   if(SessionSMBSpanSigCnt>0)
     {

      //買いシグナルの場合
      if(dRedSpan<dBlueSpan)
        {
         SetSessionSMBSSignal(SIGNALBUY,iBarNo);
        }

      //売りシグナルの場合
      else if(dRedSpan>dBlueSpan)
        {
         SetSessionSMBSSignal(SIGNALSELL,iBarNo);
        }

      //上記以外
      else
        {
         SetSessionSMBSSignal(NOSIGNAL,iBarNo);
        }

     }

//シグナル点灯していない場合
   else
     {

      //買いシグナル点灯
      if(dPreRedSpan>=dPreBlueSpan && dRedSpan<dBlueSpan)
        {
         SetSessionSMBSSignal(SIGNALBUY,iBarNo);
        }

      //売りシグナル点灯
      else if(dPreRedSpan<=dPreBlueSpan && dRedSpan>dBlueSpan)
        {
         SetSessionSMBSSignal(SIGNALSELL,iBarNo);
        }

     }

   return;
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパンチェック                                           |
//+------------------------------------------------------------------+
void CheckSMDELAYEDSPAN(int iBarNo=0)
  {

//シグナル消灯
/*
    if(SessionSMCSpanSigCnt >= LOWERSIGNALLM){
        SetSessionSMCSSignal(NOSIGNAL,iBarNo);
        return;
    }
*/
//遅行スパンの値
   double dDELAYEDSPAN=iClose(NULL,LOWERPERIOD,iBarNo+1);
   double dPreDELAYEDSPAN=iClose(NULL,LOWERPERIOD,iBarNo+2);

//遅行スパンの位置の終値
   double dClose=iClose(NULL,LOWERPERIOD,LOWERSENKOSEN+iBarNo+1);
   double dPreClose=iClose(NULL,LOWERPERIOD,LOWERSENKOSEN+iBarNo+2);

//過去n本のバーの最高値の位置
   int iHighestBarNo=iHighest(NULL,LOWERPERIOD,MODE_CLOSE,LOWERSENKOSEN,iBarNo+1);

//過去n本のバーの最安値の位置
   int iLowestBarNo=iLowest(NULL,LOWERPERIOD,MODE_CLOSE,LOWERSENKOSEN,iBarNo+1);

//買いシグナル点灯中
   if(SessionSMCSSignal==SIGNALBUY)
     {

      //シグナル消灯
      if(dPreDELAYEDSPAN>dPreClose && dDELAYEDSPAN<=dClose)
        {
         SetSessionSMCSSignal(NOSIGNAL,iBarNo);
        }

      //売りシグナル点灯
      if(iLowestBarNo==iBarNo+1)
        {
         SetSessionSMCSSignal(SIGNALSELL,iBarNo);
        }

     }

//売りシグナル点灯中
   else if(SessionSMCSSignal==SIGNALSELL)
     {

      //シグナル消灯
      if(dPreDELAYEDSPAN<dPreClose && dDELAYEDSPAN>=dClose)
        {
         SetSessionSMCSSignal(NOSIGNAL,iBarNo);
        }

      //買いシグナル点灯
      if(iHighestBarNo==iBarNo+1)
        {
         SetSessionSMCSSignal(SIGNALBUY,iBarNo);
        }
     }

//シグナルなし
   else
     {

      //買いシグナル点灯
      if(iHighestBarNo==iBarNo+1)
        {
         SetSessionSMCSSignal(SIGNALBUY,iBarNo);
        }

      //売りシグナル点灯
      else if(iLowestBarNo==iBarNo+1)
        {
         SetSessionSMCSSignal(SIGNALSELL,iBarNo);
        }

      //上記以外
      else
        {
         SetSessionSMCSSignal(NOSIGNAL,iBarNo);
        }
     }

   return;

  }
//+------------------------------------------------------------------+
//| 青色スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
void CheckCloseSignal_SMBlueSpan(string sSignal,int iBarNo=0)
  {

   bool bClosed=false;

//青色スパン
   double dBlueSpan=iCustom(NULL,LOWERPERIOD,"SpanModel",5,iBarNo+1);

//終値
   double dClose=Close[iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && dBlueSpan>=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,BLUESPAN,
               SIGNALBUY,SessionSMBSpanSigCnt,MSG0109,iBarNo);
     }
   else if(sSignal==SIGNALSELL && dBlueSpan<=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,BLUESPAN,
               SIGNALSELL,SessionSMBSpanSigCnt,MSG0110,iBarNo);
     }

   SetSessionIsClosedSMBlueSpan(bClosed);

  }
//+------------------------------------------------------------------+
//| 遅行スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
void CheckCloseSignal_SMDelayedSpan(string sSignal,int iBarNo=0)
  {

   bool bClosed=false;

//遅行スパン
   double dCSpan=Close[iBarNo+1];

//終値
   double dClose=Close[LOWERSENKOSEN+iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && dCSpan<=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,DELAYEDSPAN,
               SIGNALBUY,SessionSMCSpanSigCnt,MSG0009,iBarNo);
     }
   else if(sSignal==SIGNALSELL && dCSpan>=dClose)
     {
      bClosed=true;
      TrailLog(LOGFILENAME,INFO,SPANMODEL,DELAYEDSPAN,
               SIGNALSELL,SessionSMCSpanSigCnt,MSG0010,iBarNo);
     }

   SetSessionIsClosedSMDelayedSpan(bClosed);

  }
//+------------------------------------------------------------------+