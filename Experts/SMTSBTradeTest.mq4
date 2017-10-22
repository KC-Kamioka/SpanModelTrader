//+------------------------------------------------------------------+
//|                                               SMTSBTradeTest.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <SMTTradeMain.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   SessionTrendTicket=NOPOSITION;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   double dPlus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,0);
   double dMnus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,0);
   double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,0);
   double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,0);
   double dClose=Close[0];
   if(SessionTrendTicket==NOPOSITION)
     {

      if(dMnus2Sigma>dClose)
        {
         SessionTrendTicket=OrderSend(NULL,OP_BUY,LOTCOUNTHALF,Ask,SLIPPAGE,
                                      Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
Print(DoubleToString(dMnus2Sigma));
        }
     }
   else
     {

      if(dPlus2Sigma<dClose) PositionClose(true);
     }
  }
//+------------------------------------------------------------------+
