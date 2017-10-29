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
#include <SMTCommon.mqh>
#define KEY_RIGHT 39
#define KEY_ALL 48
#define KEY_SPANMODEL 49
#define KEY_SUPERBOLINGER 50
long lChartID=0;
string slogFileName=NULL;
int iLogIndiNameNo=3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

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
     }

   string sLogContents[];
   int iLogCount=0;
   int iHandle=FileOpen(slogFileName,FILE_READ);

//ファイルを読み込む
   while(!FileIsEnding(iHandle))
     {
      iLogCount=iLogCount+1;
      ArrayResize(sLogContents,iLogCount);
      sLogContents[iLogCount-1]=FileReadString(iHandle);
     }

//ファイルを閉じる 
   FileClose(iHandle);

   string sLogContent=NULL;
   for(int i=ArraySize(sLogContents)-1;i>0;i--)
     {
      string sLogArray[];
      StringSplit(sLogContents[i],StringGetCharacter(SMTLOGSEP,0),sLogArray);
      if(int(lparam)==KEY_RIGHT || int(lparam)==KEY_ALL)
        {
         sLogContent=sLogContent+sLogContents[i]+"\n";
        }
      else if(int(lparam)==KEY_SPANMODEL)
        {
         if(sLogArray[iLogIndiNameNo]==GetCodeContent(SPANMODEL))
           {
            sLogContent=sLogContent+sLogContents[i]+"\n";
           }
        }
      else if(int(lparam)==KEY_SUPERBOLINGER)
        {
         if(sLogArray[iLogIndiNameNo]==GetCodeContent(SUPERBOLINGER))
           {
            sLogContent=sLogContent+sLogContents[i]+"\n";
           }
        }
     }
   Comment(sLogContent);
  }
//+------------------------------------------------------------------+
