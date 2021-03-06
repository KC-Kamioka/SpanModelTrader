//+------------------------------------------------------------------+
//|                                                      SMT0001.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| ライブラリ                                                         |
//+------------------------------------------------------------------+
#include <SMT0001.mqh>
//+--------------------------------------------------------------+
//| 買いポジションオープン                                             |
//+--------------------------------------------------------------+
bool PositionOpenBuy(int iStopLoss,int iBarNo=0) export
  {

//証拠金チェック
   if(AccountFreeMarginCheck(Symbol(),OP_BUY,LOTCOUNT)<=0 || 
      GetLastError()==ERR_NOT_ENOUGH_MONEY)
     {
      //ログ出力
      string sErrMessage=ErrorDescription(ERR_NOT_ENOUGH_MONEY);
      SendNotification(Symbol()+" "+sErrMessage);
      return false;
     }

//買いポジションオープン
   int iRtnTicketNo=OrderSend(NULL,OP_BUY,LOTCOUNT,Ask,SLIPPAGE,
                              Ask-iStopLoss*Point,Ask+TAKEPROFIT*Point,NULL,NULL,NULL,clrAqua);
   if(iRtnTicketNo==-1)
     {
      int iLastError=GetLastError();
      string sErrMessage=ErrorDescription(iLastError);
      SendNotification(Symbol()+" "+sErrMessage);
     }
   return true;
  }
//+--------------------------------------------------------------+
//| 売りポジションオープン                                             |
//+--------------------------------------------------------------+
bool PositionOpenSell(int iStopLoss,int iBarNo=0) export
  {

//証拠金チェック
   if(AccountFreeMarginCheck(Symbol(),OP_SELL,LOTCOUNT)<=0 || 
      GetLastError()==ERR_NOT_ENOUGH_MONEY)
     {
      //ログ出力
      string sErrMessage=ErrorDescription(ERR_NOT_ENOUGH_MONEY);
      SendNotification(Symbol()+" "+sErrMessage);
      return false;
     }

//売りポジションオープン
   int iRtnTicketNo=OrderSend(NULL,OP_SELL,LOTCOUNT,Bid,SLIPPAGE,
                              Bid+iStopLoss*Point,Bid-TAKEPROFIT*Point,NULL,NULL,NULL,clrDarkRed);
   if(iRtnTicketNo==-1)
     {
      int iLastError=GetLastError();
      string sErrMessage=ErrorDescription(iLastError);
      SendNotification(Symbol()+" "+sErrMessage);
     }
   return true;
  }
//+------------------------------------------------------------------+
//| ブレイクイーブン                                                    |
//+------------------------------------------------------------------+
void BreakEven() export
  {

//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      string oSymbol=Symbol();
      if(OrderSymbol()==oSymbol)
        {
         //
         int oType=OrderType();
         int oTicket=OrderTicket();
         double oPrice=OrderOpenPrice();
         double oStopLoss=OrderStopLoss();
         double oTakeProfit=OrderTakeProfit();
         double stop=200*Point;
         if(oType==OP_BUY)
           {
            double price=MarketInfo(oSymbol,MODE_BID);

            if(price>=oPrice+stop)
              {
               // 何度もmodifyしないためのif文
               if(oStopLoss!=oPrice)
                 {
                  Print("ロングポジションの損切りライン変更：",DoubleToStr(oStopLoss)," ⇒ ",DoubleToStr(oPrice+stop));
                  bool bModified=OrderModify(oTicket,oPrice,oPrice,oTakeProfit,clrAntiqueWhite);
                  if(bModified==false)
                    {
                     int iLastError=GetLastError();
                     string sErrMessage=ErrorDescription(iLastError);
                     SendNotification(Symbol()+" "+sErrMessage);
                    }
                 }
              }
           }
         else if(oType==OP_SELL)
           {
            double price=MarketInfo(oSymbol,MODE_ASK);
            if(price<=oPrice-stop)
              {
               // 何度もmodifyしないためのif文
               if(oStopLoss!=oPrice)
                 {
                  Print("ショートポジションの損切りライン変更：",DoubleToStr(oStopLoss)," ⇒ ",DoubleToStr(oPrice-stop));
                  bool bModified=OrderModify(oTicket,oPrice,oPrice,oTakeProfit,clrAntiqueWhite);
                  if(bModified==false)
                    {
                     int iLastError=GetLastError();
                     string sErrMessage=ErrorDescription(iLastError);
                     SendNotification(Symbol()+" "+sErrMessage);
                    }
                 }
              }
           }
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//| ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionClose(double CloseLot) export
  {
//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {

         //ポジションクローズ
         bool Closed=OrderClose(OrderTicket(),CloseLot,OrderClosePrice(),SLIPPAGE,Magenta);
         if(Closed==true)
           {
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            SendNotification(Symbol()+" "+sErrMessage);
           }
         break;
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//| 残ポジション検索                                                    |
//+------------------------------------------------------------------+
bool IsExistPosition(int iBarNo=0) export
  {

   bool IsExist=false;
//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         IsExist=true;
         break;
        }
     }
   return IsExist;
  }
//+------------------------------------------------------------------+
//| 全ポジションクローズ                                                    |
//+------------------------------------------------------------------+
void PositionCloseAll() export
  {

//オーダー情報取得
   for(int i=0; i<OrdersTotal(); i++)
     {
      bool bSelected=OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol())
        {
         //ポジションクローズ
         bool Closed=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),SLIPPAGE,Magenta);
         if(Closed==true)
           {
              }else{
            int iLastError=GetLastError();
            string sErrMessage=ErrorDescription(iLastError);
            SendNotification(Symbol()+" "+sErrMessage);
           }
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//| 週末ポジションチェック                                                       |
//+------------------------------------------------------------------+
bool IsWeekend(int iBarNo) export
  {

//週末ポジション持越しない
   bool bRtn=false;
   if(TimeDayOfWeek(Time[iBarNo])==5 && TimeHour(Time[iBarNo])>22)
     {
      bRtn=true;
     }
   return bRtn;
  }
//+------------------------------------------------------------------+
