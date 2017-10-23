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
int iBuyTicket1=0;
int iBuyTicket2=0;
int iBuyTicket3=0;
int iSellTicket1=0;
int iSellTicket2=0;
int iSellTicket3=0;
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
  // TradeSell();
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
   if(iBuyTicket1==NOPOSITION){
   iBuyTicket1=GetTicketNo();
   }
   
   if(iBuyTicket2==NOPOSITION){
   iBuyTicket1=GetTicketNo();
   }
   
   if(iBuyTicket2==NOPOSITION){
   iBuyTicket2=GetTicketNo();
   }
   if(iBuyTicket1==NOPOSITION && dSimpleMA>dClose)
     {
      iBuyTicket1=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }
   if(iBuyTicket2==NOPOSITION && dMnus1Sigma>dClose)
     {
      iBuyTicket2=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }
   if(iBuyTicket3==NOPOSITION && dMnus2Sigma>dClose)
     {
      iBuyTicket3=OrderSend(NULL,OP_BUY,CLOSELOT,Ask,SLIPPAGE,
                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
     }

   if(dPlus2Sigma<dClose)
     {
      if(iBuyTicket1!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iBuyTicket1,SELECT_BY_TICKET);
         bool Closed=OrderClose(iBuyTicket1,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iBuyTicket1=NOPOSITION;
        }
      if(iBuyTicket2!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iBuyTicket2,SELECT_BY_TICKET);
         bool Closed=OrderClose(iBuyTicket2,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iBuyTicket2=NOPOSITION;
        }
      if(iBuyTicket3!=NOPOSITION)
        {
         bool bSelected=OrderSelect(iBuyTicket3,SELECT_BY_TICKET);
         bool Closed=OrderClose(iBuyTicket3,CLOSELOT,OrderClosePrice(),SLIPPAGE,Magenta);
         iBuyTicket3=NOPOSITION;
        }
     }
  }
//+------------------------------------------------------------------+
