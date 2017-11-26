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
#include <SMT0000.mqh>
#include <SMT0003.mqh>

#define KEY_LEFT 37
#define KEY_UP 38
#define KEY_RIGHT 39
#define KEY_DOWN 40
int iSymbolNo=0;
int iSMTOBarNo=0;
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
      //次の通貨をセット
      iSymbolNo=iSymbolNo+1;
      if(iSymbolNo==ArraySize(OpenSymbol)) iSymbolNo=0;
     }

//左キーが押下されたとき
   else if(int(lparam)==KEY_LEFT)
     {
      //前の通貨をセット
      iSymbolNo=iSymbolNo-1;
      if(iSymbolNo<0) iSymbolNo=ArraySize(OpenSymbol)-1;
     }

//下キーが押下されたとき
   else if(int(lparam)==KEY_DOWN)
     {
      //次の時間をセット
      iSMTOBarNo=iSMTOBarNo+Adjust_BarNo;
     }

//下キーが押下されたとき
   else if(int(lparam)==KEY_UP)
     {
      //次の時間をセット
      iSMTOBarNo=iSMTOBarNo-Adjust_BarNo;
      if(iSMTOBarNo<0) iSMTOBarNo=0;
     }

//通貨ペア
   string sSymbol=OpenSymbol[iSymbolNo];

//時間
   datetime dtTimeClose=iTimeMTF(sSymbol,iSMTOBarNo);

//コメント表示
   string sContents="通貨ペア:"+sSymbol+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"始値:"+DoubleToString(iOpenMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"終値:"+DoubleToString(iCloseMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"高値:"+DoubleToString(iHighestMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   sContents=sContents+TimeToString(dtTimeClose)+" "+"安値:"+DoubleToString(iLowestMTF(sSymbol,iSMTOBarNo))+SMTRTNCODE;
   Comment(sContents);
  }
//+------------------------------------------------------------------+
