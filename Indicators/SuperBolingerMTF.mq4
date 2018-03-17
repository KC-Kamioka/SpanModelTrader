//+------------------------------------------------------------------+
//|                                             SuperBolingerMTF.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 8

//---- libraries
#include <SMT0000.mqh>
#include <SMT0003.mqh>

//---- buffers
double DelayedSpan[];
double SimpleMA[];
double Plus1Sigma[];
double Mnus1Sigma[];
double Plus2Sigma[];
double Mnus2Sigma[];
double Plus3Sigma[];
double Mnus3Sigma[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,3,clrMagenta);
   SetIndexBuffer(0,DelayedSpan);
   SetIndexShift(0,-UPPERDELAYEDSPANBARNO);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2,clrAquamarine);
   SetIndexBuffer(1,SimpleMA);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2,clrOrange);
   SetIndexBuffer(2,Plus1Sigma);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2,clrOrange);
   SetIndexBuffer(3,Mnus1Sigma);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,2,clrBlueViolet);
   SetIndexBuffer(4,Plus2Sigma);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,2,clrBlueViolet);
   SetIndexBuffer(5,Mnus2Sigma);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,2,clrYellow);
   SetIndexBuffer(6,Plus3Sigma);
   SetIndexStyle(7,DRAW_LINE,STYLE_SOLID,2,clrYellow);
   SetIndexBuffer(7,Mnus3Sigma);

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
   SuperBolingerPrice sbr;
   for(int i=0; i<rates_total-UPPERDELAYEDSPANBARNO-1; i++)
   {
      if(GetSuperBolingerRate(sbr,i))
      {
         DelayedSpan[i] = sbr.dDelayedSpan;
         SimpleMA[i]    = sbr.dSimpleMA;
         Plus1Sigma[i]  = sbr.dPlus1Sigma;
         Mnus1Sigma[i]  = sbr.dMnus1Sigma;
         Plus2Sigma[i]  = sbr.dPlus2Sigma;
         Mnus2Sigma[i]  = sbr.dMnus2Sigma;
         Plus3Sigma[i]  = sbr.dPlus3Sigma;
         Mnus3Sigma[i]  = sbr.dMnus3Sigma;
      }
   }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
