//+------------------------------------------------------------------+
//|                                                  SMTOperator.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#include <SMTConstants.mqh>
#define KEY_LEFT  37
#define KEY_RIGHT 39

long lChartID=0;
string slogFileName=NULL;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   lChartID=ChartFirst();
   while(lChartID>0)
     {

      //現在のチャート
      if(lChartID==ChartID())
        {
         //次のチャートをセット
         lChartID=ChartNext(lChartID);
           }else{

         //チャートの期間変更
         //  ChartSetSymbolPeriod(lChartID,ChartSymbol(),PERIOD_M5);

         //テンプレート適用
         //  ChartApplyTemplate(lChartID,SMTTEMPLATE);

         Print(ChartSymbol());
         Print(lChartID);

         //次のチャートをセット
         lChartID=ChartNext(lChartID);
        }
     }
   lChartID=ChartFirst();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
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

//右キーが押下されたとき
   if(int(lparam)==KEY_RIGHT)
     {
      //次のチャートをセット
      lChartID=ChartNext(lChartID);

      //次のチャートがない場合または現在のチャートではない場合、最初のチャートを設定する。
      if(lChartID<0 || lChartID==ChartID())lChartID=ChartFirst();

      //ログファイル名をセット
      slogFileName="TrailLog_"+ChartSymbol(lChartID)+".csv";

      string sLogContents[];
      int iLogCount=0;
      int iHandle=FileOpen(slogFileName,FILE_READ);
      while(!FileIsEnding(iHandle))
        {
         iLogCount=iLogCount+1;
         ArrayResize(sLogContents,iLogCount);
         sLogContents[iLogCount-1]=FileReadString(iHandle);
        }
      //---ファイルを閉じる 
      FileClose(iHandle);

      string sLogContent=NULL;
      for(int i=ArraySize(sLogContents)-1;i>0;i--)
        {
         sLogContent=sLogContent+sLogContents[i]+"\n";
        }
      Comment(sLogContent);
      Print(slogFileName);
     }
//左キーが押下されたとき
   else if(int(lparam)==KEY_LEFT)
     {
      //Comment();
     }
  }
//+------------------------------------------------------------------+
