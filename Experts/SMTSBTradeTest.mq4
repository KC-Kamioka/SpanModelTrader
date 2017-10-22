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
SessionOpenSignal==SIGNALBUY;
SessionTrendTicket=NOPOSITION;
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

//チケット番号取得
   if(SessionTrendTicket==NOPOSITION) SearchExistPosition();

//基準線の値超えていない場合
   if(SessionSBSimpleMASigCnt<LOWERKIJUNSEN-1)
     {

      double dPlus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,1,0);
      double dMnus1Sigma=iBands(NULL,PERIOD_M5,21,1,0,PRICE_CLOSE,2,0);
      double dPlus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,1,0);
      double dMnus2Sigma=iBands(NULL,PERIOD_M5,21,2,0,PRICE_CLOSE,2,0);
      double dClose=Close[0];

      //ポジション保持中の場合
      if(SessionTrendTicket!=NOPOSITION)
        {

         //プラスマイナス２を超えた場合利食い
         if(dPlus2Sigma<dClose || dMnus2Sigma>dClose) PositionClose(true);

        }

      //ポジションがない場合
      else
        {

         //買いポジションオープン
         if(SessionOpenSignal==SIGNALBUY && dMnus2Sigma>dClose)
           {
            //SessionTrendTicket=OrderSend(NULL,OP_BUY,LOTCOUNTHALF,Ask,SLIPPAGE,
            SessionTrendTicket=OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,SLIPPAGE,
                                         Ask-STOPLOSS*Point,NULL,NULL,NULL,NULL,clrAqua);
           }

         //売りポジションオープン
         if(SessionOpenSignal==SIGNALSELL && dPlus2Sigma<dClose)
           {
            //SessionTrendTicket=OrderSend(NULL,OP_SELL,LOTCOUNTHALF,Bid,SLIPPAGE,
            SessionTrendTicket=OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,SLIPPAGE,
                                         Bid+STOPLOSS*Point,NULL,NULL,NULL,NULL,clrDarkRed);
           }

        }
     }
  }
//+------------------------------------------------------------------+
