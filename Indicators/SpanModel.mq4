//+------------------------------------------------------------------+
//|                                                    SpanModel.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3

//---- buffers
double BlueSpan[];
double RedSpan[];
double DelayedSpan[];

//---- libraries
#include <SMT0000.mqh>
#include <SMT0002.mqh>

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1,Blue);
   SetIndexBuffer(0,BlueSpan);
   SetIndexShift(0,0);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,Red);
   SetIndexBuffer(1,RedSpan);
   SetIndexShift(1,0);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1,Magenta);
   SetIndexBuffer(2,DelayedSpan);
   SetIndexShift(2,-26);
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
   SpanModelRate smr;
   for(int i=0; i<rates_total-1; i++)
   {
      GetSpanModelRate(smr,i);
      DelayedSpan[i] = smr.dSMDelayedSpan;
      BlueSpan[i]    = smr.dBlueSpan;
      RedSpan[i]     = smr.dRedSpan;
 
      string sObjName = "Span_" + TimeToString(Time[i]);
      if(ObjectFind(sObjName)<0)
      {
         ObjectCreate(0,sObjName,OBJ_RECTANGLE,0,Time[i],BlueSpan[i],Time[i],RedSpan[i]);
         ObjectSetInteger(0,sObjName,OBJPROP_BACK,false);
         if(BlueSpan[i]>RedSpan[i])
         {
            ObjectSetInteger(0,sObjName,OBJPROP_COLOR,Blue);
         }else{
            ObjectSetInteger(0,sObjName,OBJPROP_COLOR,Red);
         }
      }
   }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
