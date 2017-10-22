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
int iTicket1=0;
int iTicket2=0;
int iTicket3=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

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
   TradeBuy();
//   TradeSell();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeBuy()
  {

   double dSimpleMA=iBands(NULL,PERIOD_M5,21,0,0,PRICE_CLOSE,1,0);
   double dPlus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,0);
   double dMnus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,0);
   double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,0);
   double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,0);
   double dClose=Close[0];
   if(iTicket1==NOPOSITION && dSimpleMA>dClose)
     {
      iTicket1=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }
   if(iTicket2==NOPOSITION && dMnus1Sigma>dClose)
     {
      iTicket2=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }
   if(iTicket3==NOPOSITION && dMnus2Sigma>dClose)
     {
      iTicket3=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }

   if(dPlus2Sigma<dClose)
     {
      if(iTicket1!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket1,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket1,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket1=NOPOSITION;
        }
      if(iTicket2!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket2,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket2,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket2=NOPOSITION;
        }
      if(iTicket3!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket3,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket3,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket3=NOPOSITION;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeSell()
  {

   double dSimpleMA=iBands(NULL,PERIOD_M5,21,0,0,PRICE_CLOSE,1,0);
   double dPlus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,0);
   double dMnus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,0);
   double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,0);
   double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,0);
   double dClose=Close[0];
   if(iTicket1==NOPOSITION && dSimpleMA<dClose)
     {
      iTicket1=OrderSend(NULL,OP_SELL,CLOSELOT,Bid,SLIPPAGE,
                         Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrRed);
     }
   if(iTicket2==NOPOSITION && dPlus1Sigma<dClose)
     {
      iTicket2=OrderSend(NULL,OP_BUY,CLOSELOT,Bid,SLIPPAGE,
                         Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrRed);
     }
   if(iTicket3==NOPOSITION && dPlus2Sigma<dClose)
     {
      iTicket3=OrderSend(NULL,OP_BUY,CLOSELOT,Bid,SLIPPAGE,
                         Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrRed);
     }

   if(dMnus2Sigma>dClose)
     {
      if(iTicket1!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket1,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket1,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket1=NOPOSITION;
        }
      if(iTicket2!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket2,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket2,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket2=NOPOSITION;
        }
      if(iTicket3!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iTicket3,SELECT_BY_TICKET);
         bool Closed=OrderClose(iTicket3,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iTicket3=NOPOSITION;
        }
     }
  }
//+------------------------------------------------------------------+
