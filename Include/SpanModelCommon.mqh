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
//| 定数.                                                            |
//+------------------------------------------------------------------+
#define SM_INDICATORNAME  "SpanModel"
#define SM_BLUESPAN 5
#define SM_REDSPAN  6
//+------------------------------------------------------------------+
//| スパンモデル青色スパンチェック                                        |
//+------------------------------------------------------------------+
string CheckSMBlueSpan(int iBarNo)
  {

//処理開始ログ出力
   string sProcessName="CheckSMBlueSpan";
   TrailLog("INFO",sProcessName,iBarNo);

   string sRtnSignal=NOSIGNAL;

//シグナル消灯
   if(SessionSMBSpanSigCnt>=LOWERSIGNALLM)
     {
      return sRtnSignal;
     }

//青色スパン
   double dBlueSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_BLUESPAN,iBarNo+1);
   double dPreBlueSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_BLUESPAN,iBarNo+2);

//赤色スパン
   double dRedSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_REDSPAN,iBarNo+1);
   double dPreRedSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_REDSPAN,iBarNo+2);

//買いシグナルの場合
   if(dRedSpan<dBlueSpan)
     {
      sRtnSignal=SIGNALBUY;
     }

//売りシグナルの場合
   else if(dRedSpan>dBlueSpan)
     {
      sRtnSignal=SIGNALSELL;
     }

//上記以外
   else
     {
      sRtnSignal=NOSIGNAL;
     }
      
//処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return sRtnSignal;
  }
//+------------------------------------------------------------------+
//| スパンモデル遅行スパンチェック                                           |
//+------------------------------------------------------------------+
string CheckSMDelayedSpan(int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckSMDelayedSpan";
   TrailLog("INFO",sProcessName,iBarNo);

   string sRtnSignal=NOSIGNAL;

//遅行スパンの値
   double dDelayedSpan=iClose(NULL,PERIOD_M5,iBarNo+1);
   double dPreDelayedSpan=iClose(NULL,PERIOD_M5,iBarNo+2);

//遅行スパンの位置の終値
   double dClose=iClose(NULL,PERIOD_M5,LOWERSENKOSEN+iBarNo+1);
   double dPreClose=iClose(NULL,PERIOD_M5,LOWERSENKOSEN+iBarNo+2);

//過去n本のバーの最高値の位置
   int iHighestBarNo=iHighest(NULL,PERIOD_M5,MODE_CLOSE,LOWERSENKOSEN,iBarNo+1);

//過去n本のバーの最安値の位置
   int iLowestBarNo=iLowest(NULL,PERIOD_M5,MODE_CLOSE,LOWERSENKOSEN,iBarNo+1);

//買いシグナル点灯中
   if(SessionSMCSSignal==SIGNALBUY)
     {

      //シグナル消灯
      if(dPreDelayedSpan>dPreClose && dDelayedSpan<=dClose)
        {
         sRtnSignal=NOSIGNAL;
        }

      //売りシグナル点灯
      if(iLowestBarNo==iBarNo+1)
        {
         sRtnSignal=SIGNALSELL;
        }

     }

//売りシグナル点灯中
   else if(SessionSMCSSignal==SIGNALSELL)
     {

      //シグナル消灯
      if(dPreDelayedSpan<dPreClose && dDelayedSpan>=dClose)
        {
         sRtnSignal=NOSIGNAL;
        }

      //買いシグナル点灯
      if(iHighestBarNo==iBarNo+1)
        {
         sRtnSignal=SIGNALBUY;
        }
     }

//シグナルなし
   else
     {

      //買いシグナル点灯
      if(iHighestBarNo==iBarNo+1)
        {
         sRtnSignal=SIGNALBUY;
        }

      //売りシグナル点灯
      else if(iLowestBarNo==iBarNo+1)
        {
         sRtnSignal=SIGNALSELL;
        }

      //上記以外
      else
        {
         sRtnSignal=NOSIGNAL;
        }
     }
       //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return sRtnSignal;

  }
//+------------------------------------------------------------------+
//| 青色スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMBlueSpan(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SMBlueSpan";
   TrailLog("INFO",sProcessName,iBarNo);

   bool bClosed=false;

//青色スパン
   double dBlueSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_BLUESPAN,iBarNo+1);

//赤色スパン
   double dRedSpan=iCustom(NULL,PERIOD_M5,SM_INDICATORNAME,SM_REDSPAN,iBarNo+1);

//終値
   double dClose=Close[iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY&& dBlueSpan>=dClose)
     {
      bClosed=true;
      TrailLog("INFO","MSG0109",iBarNo);
     }
   else if(sSignal==SIGNALBUY && dBlueSpan<=dRedSpan)
     {
      bClosed=true;
      TrailLog("INFO","MSG0109",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dBlueSpan<=dClose)
     {
      bClosed=true;
      TrailLog("INFO","MSG0110",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dBlueSpan>=dRedSpan)
     {
      bClosed=true;
      TrailLog("INFO","MSG0110",iBarNo);
     }
     
   //処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| 遅行スパン決済シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckCloseSignal_SMDelayedSpan(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckCloseSignal_SMDelayedSpan";
   TrailLog("INFO",sProcessName,iBarNo);

   bool bClosed=false;

//遅行スパン
   double dCSpan=Close[iBarNo+1];

//終値
   double dClose=Close[LOWERSENKOSEN+iBarNo+1];

//決済シグナル確認
   if(sSignal==SIGNALBUY && dCSpan<=dClose)
     {
      bClosed=true;
      TrailLog("INFO","MSG0009",iBarNo);
     }
   else if(sSignal==SIGNALSELL && dCSpan>=dClose)
     {
      bClosed=true;
      TrailLog("INFO","MSG0010",iBarNo);
     }

//処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
//| 遅行スパン利確シグナルチェック                                                |
//+------------------------------------------------------------------+
bool CheckTProfitSignal_SMDelayedSpan(string sSignal,int iBarNo)
  {
//処理開始ログ出力
   string sProcessName="CheckTProfitSignal_SMDelayedSpan";
   TrailLog("INFO",sProcessName,iBarNo);
   
   bool bClosed=false;
   int iCheckStep=0;
   double dTProfitPoint= 0;
   double dRequestRate = 0;

//買いシグナルの場合
   if(sSignal==SIGNALBUY)
     {
      double dLowestClose=0;
      for(int i=LOWERSENKOSEN+iBarNo+1; i>iBarNo; i--)
        {

         //終値
         double dClose=Close[iBarNo+1];

         //押し目チェック
         if(iCheckStep==0)
           {
            //移動平均線
            double dSMA=iMA(NULL,PERIOD_CURRENT,UPPERSENKOSEN,0,MODE_SMA,PRICE_CLOSE,iBarNo+1);
            if(dSMA>dClose) iCheckStep=iCheckStep+1;
           }

         //押し目の場合
         if(iCheckStep==1)
           {

            //期間内の最安値の位置
            int iLowestBarNo=iLowest(NULL,PERIOD_CURRENT,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+1);

            //期間内の最高値の位置
            int iHighestBarNo=iHighest(NULL,PERIOD_CURRENT,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+1);

            //決済ポイント算出
            dTProfitPoint=Close[iHighestBarNo]-Close[iLowestBarNo];
            dLowestClose=dClose;

            //指値設定
            dRequestRate=dClose+dTProfitPoint;
            iCheckStep=iCheckStep+1;
            Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                  "指値確定:"+DoubleToString(dRequestRate));
           }

         //押し目後
         if(iCheckStep==2)
           {

            //指値変更
            if(dLowestClose>dClose)
              {
               dRequestRate=dClose+dTProfitPoint;
               dLowestClose=dClose;
               Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                     "指値変更:"+DoubleToString(dRequestRate));
              }

            //指値まで上昇
            if(dRequestRate<=dClose)
              {
               bClosed=true;
               TrailLog("INFO","MSG0023",iBarNo);
               Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                     "利益確定");
               break;
              }
           }
        }

     }

//売りシグナルの場合
   else if(sSignal==SIGNALSELL)
     {
      double dHighestClose=0;
      for(int i=LOWERSENKOSEN+iBarNo+1; i>iBarNo; i--)
        {

         //終値
         double dClose=Close[iBarNo+1];

         //戻りチェック
         if(iCheckStep==0)
           {

            //移動平均線
            double dSMA=iMA(NULL,PERIOD_CURRENT,UPPERSENKOSEN,0,MODE_SMA,PRICE_CLOSE,iBarNo+1);
            if(dSMA<dClose) iCheckStep=iCheckStep+1;
           }

         //戻りの場合
         if(iCheckStep==1)
           {

            //期間内の最安値の位置
            int iLowestBarNo=iLowest(NULL,PERIOD_CURRENT,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+1);

            //期間内の最高値の位置
            int iHighestBarNo=iHighest(NULL,PERIOD_CURRENT,MODE_CLOSE,LOWERSENKOSEN+1,iBarNo+1);

            //決済ポイント算出
            dTProfitPoint=Close[iHighestBarNo]-Close[iLowestBarNo];
            dHighestClose=dClose;

            //指値設定
            dRequestRate=dClose-dTProfitPoint;
            iCheckStep=iCheckStep+1;
            Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                  "指値確定:"+DoubleToString(dRequestRate));
           }

         //戻り後
         if(iCheckStep==2)
           {

            //指値変更
            if(dHighestClose<dClose)
              {
               dRequestRate=dClose-dTProfitPoint;
               dHighestClose=dClose;
               Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                     "指値変更:"+DoubleToString(dRequestRate));
              }

            // 指値まで上昇
            if(dRequestRate>=dClose)
              {
               bClosed=true;
               TrailLog("INFO","MSG0023",iBarNo);
               Print(TimeToString(Time[iBarNo])+" "+Symbol()+" "+
                     "利益確定");
               break;
              }
           }
        }
     }
     
//処理終了ログ出力
   TrailLog("INFO",sProcessName,iBarNo);
   return bClosed;

  }
//+------------------------------------------------------------------+
