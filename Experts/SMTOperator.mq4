//+------------------------------------------------------------------+
//|                                                  SMTOperator.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <SMTConstants.mqh>
#define KEY_LEFT  37

long lChartID=0;
string OpenSymbol[10]=
  {
   "USDJPY",
   "GBPJPY",
   "GBPUSD",
   "EURJPY",
   "EURUSD",
   "AUDJPY",
   "AUDUSD",
   "EURGBP",
   "EURAUD",
   "GBPAUD"
  };
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//キーが押下された場合
   if(id!=CHARTEVENT_KEYDOWN) return;
//左キーが押下されたとき
   if(int(lparam)==KEY_LEFT)
     {
      //現在表示中のチャートを閉じる
      lChartID=ChartFirst();
      while(lChartID>0)
        {
         //現在のチャートの場合
         if(lChartID==ChartID())
           {
            //次のチャートをセット
            lChartID=ChartNext(lChartID);
           }
         else
           {
            //チャートを閉じる
            ChartClose(lChartID);

            //次のチャートをセット
            lChartID=ChartNext(lChartID);
           }
        }
      //チャートを開く
      for(int i=0;i<ArraySize(OpenSymbol);i++)
        {
         //チャートを開く
         lChartID=ChartOpen(OpenSymbol[i],PERIOD_M5);

         //テンプレート適用
         ChartApplyTemplate(lChartID,SMTTEMPLATE);
        }
      //初めのチャートIDをセット
      lChartID=ChartFirst();
     }
   ExpertRemove();
  }
//+------------------------------------------------------------------+   
